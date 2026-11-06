"""Build the five Getting Started hero animations as Rive runtime files.

Usage: python3 tool/rive/build_getting_started.py [out_dir]   (default: assets/rive)

Each file is written directly in Rive's runtime binary format (v7.5), the same
way as the Scorbord `bet_placed.riv`, because the Rive editor connector wasn't
connected. The files also open in the Rive editor.

Every file has the same shape, so one Flutter widget plays all of them:

* Artboard: named after the scene (see SCENES), 480 x 270, transparent.
* View model `GettingStarted` with one boolean, `reduceMotion`.
* Animations: `loop` (3 s, loops seamlessly) and `still` (1 frame, the pose
  shown when reduced motion is on).
* State machine `State Machine 1`: entry -> loop; loop -> still when
  `reduceMotion` is true; still -> loop when it is false.

Colors are the app's accents (Material accent colors used across the course).
"""
import json, math, os, struct, sys

HERE = os.path.dirname(os.path.abspath(__file__))
M = json.load(open(os.path.join(HERE, 'meta.json')))
T = M['types']; PT = {int(k): v for k, v in M['ptype'].items()}
T['ViewModelInstanceValue']['props']['v5'] = 5
PT[588] = 'bytes'

W, H = 480, 270
FPS = 60
DUR = 3.0
D = int(DUR * FPS)


def props_of(cls):
    out = {}
    c = cls
    while c in T:
        for n, k in T[c]['props'].items():
            out.setdefault(n, k)
        c = T[c]['parent']
    return out


def vu(n):
    out = bytearray()
    while True:
        b = n & 127; n >>= 7
        if n: out.append(b | 128)
        else: out.append(b); return bytes(out)


def color(hexstr, a=255):
    return (a << 24) | int(hexstr.lstrip('#'), 16)


# ---------------------------------------------------------------- palette
CARD = color('2A2A3C'); CARD_DARK = color('14141E'); LINE = color('3A3A52')
WHITE = color('FFFFFF'); SOFT = color('FFFFFF', 150); FAINT = color('FFFFFF', 40)
GREEN = color('69F0AE'); LIME = color('B2FF59'); BLUE = color('448AFF')
PURPLE = color('E040FB'); CYAN = color('18FFFF'); AMBER = color('FFC107')
ORANGE = color('FF9100'); RED = color('FF5252'); TEAL = color('64FFDA')


class Riv:
    """Collects one file's objects in order and writes it."""

    def __init__(self):
        self.objs = []
        self.ci = {}
        self.count = 0
        self.tracks = {}

    def add(self, cls, **p):
        self.objs.append((cls, p))

    def comp(self, handle, cls, parent=None, **p):
        if parent is not None:
            p['parentId'] = self.ci[parent]
        self.add(cls, **p)
        self.ci[handle] = self.count
        self.count += 1

    # shapes -------------------------------------------------------------
    def node(self, h, parent, x=0, y=0, **p):
        self.comp(h, 'Node', parent, x=x, y=y, **p)

    def _paint(self, h, col, line, thick):
        if col is not None:
            self.comp(h + '_fill', 'Fill', h)
            self.comp(h + '_color', 'SolidColor', h + '_fill', colorValue=col)
        if line is not None:
            self.comp(h + '_stroke', 'Stroke', h, thickness=thick, cap=1, join=1)
            self.comp(h + '_scolor', 'SolidColor', h + '_stroke', colorValue=line)

    def rect(self, h, parent, x, y, w, hh, col=None, r=0, line=None, thick=0, **p):
        self.comp(h, 'Shape', parent, x=x, y=y, **p)
        extra = {'cornerRadiusTL': r, 'linkCornerRadius': True} if r else {}
        self.comp(h + '_path', 'Rectangle', h, width=w, height=hh, **extra)
        self._paint(h, col, line, thick)

    def ellipse(self, h, parent, x, y, w, hh, col=None, line=None, thick=0, **p):
        self.comp(h, 'Shape', parent, x=x, y=y, **p)
        self.comp(h + '_path', 'Ellipse', h, width=w, height=hh)
        self._paint(h, col, line, thick)

    def poly(self, h, parent, pts, col=None, x=0, y=0, line=None, thick=0, closed=True, **p):
        self.comp(h, 'Shape', parent, x=x, y=y, **p)
        self.comp(h + '_path', 'PointsPath', h, isClosed=closed)
        for i, (vx, vy) in enumerate(pts):
            self.comp(f'{h}_v{i}', 'StraightVertex', h + '_path', x=vx, y=vy)
        self._paint(h, col, line, thick)

    def bar(self, h, parent, x, y, w, hh, col, r=None, **p):
        """A bar that grows from its left edge: key `h` scaleX 0..1."""
        self.node(h, parent, x=x, y=y, **p)
        self.rect(h + '_r', h, w / 2, 0, w, hh, col, r=hh / 2 if r is None else r)

    # animation ----------------------------------------------------------
    def key(self, h, prop, kfs):
        """kfs: [(seconds, value)], must start at 0 and end at DUR with equal values."""
        assert kfs[0][0] == 0 and abs(kfs[-1][0] - DUR) < 1e-9, (h, prop)
        self.tracks.setdefault(h, {})[prop] = kfs

    def sample(self, kfs, t):
        for (t0, v0), (t1, v1) in zip(kfs, kfs[1:]):
            if t0 <= t <= t1:
                return v0 if t1 == t0 else v0 + (v1 - v0) * (t - t0) / (t1 - t0)
        return kfs[-1][1]

    def finish(self, name, still_at):
        # interpolator (kept in the artboard's object list, no component index)
        self.add('CubicEaseInterpolator', x1=0.42, y1=0.0, x2=0.58, y2=1.0)
        ease = self.count  # same trick as bet_placed.riv
        node_props = props_of('Node')

        def keyed(tracks, frames_of, eased):
            for h, trk in tracks.items():
                self.add('KeyedObject', objectId=self.ci[h])
                for prop, kfs in trk.items():
                    self.add('KeyedProperty', propertyKey=node_props[prop])
                    for fr, v in frames_of(kfs):
                        kw = ({'interpolationType': 2, 'interpolatorId': ease}
                              if eased else {'interpolationType': 1})
                        self.add('KeyFrameDouble', frame=fr, value=v, **kw)

        def loop_frames(kfs):
            seen = set()
            for t, v in kfs:
                fr = int(round(t * FPS))
                if fr in seen:
                    fr += 1
                seen.add(fr)
                yield fr, v

        self.add('LinearAnimation', name='loop', fps=FPS, duration=D, loopValue=1)
        keyed(self.tracks, loop_frames, True)
        self.add('LinearAnimation', name='still', fps=FPS, duration=1, loopValue=0)
        keyed(self.tracks, lambda kfs: [(0, self.sample(kfs, still_at))], False)

        self.add('StateMachine', name='State Machine 1')
        self.add('StateMachineLayer', name='Layer 1')
        LOOP, STILL = 3, 4  # after AnyState, ExitState, EntryState
        self.add('AnyState'); self.add('ExitState'); self.add('EntryState')
        self.add('StateTransition', stateToId=LOOP)

        def cond_bool(value):
            self.add('TransitionViewModelCondition')
            self.add('BindablePropertyBoolean')
            self.add('DataBindContext', propertyKey=634, sourcePathIds=bytes([0, 0]))
            self.add('TransitionPropertyViewModelComparator')
            self.add('TransitionValueBooleanComparator', **({'value': 1} if value else {}))

        self.add('AnimationState', animationId=0)
        self.add('StateTransition', stateToId=STILL, duration=0)
        cond_bool(True)
        self.add('AnimationState', animationId=1)
        self.add('StateTransition', stateToId=LOOP, duration=0)
        cond_bool(False)

    def write(self, path):
        used = {}
        body = bytearray()
        for cls, p in self.objs:
            ap = props_of(cls)
            body += vu(T[cls]['key'])
            for n, v in p.items():
                k = ap[n]; t = PT[k]
                body += vu(k)
                if t == 'bool': body.append(1 if v else 0); used[k] = 0
                elif t == 'uint': body += vu(int(v)); used[k] = 0
                elif t == 'double': body += struct.pack('<f', float(v)); used[k] = 2
                elif t == 'color': body += struct.pack('<I', v); used[k] = 3
                elif t == 'string': b = v.encode(); body += vu(len(b)) + b; used[k] = 1
                elif t == 'bytes': body += vu(len(v)) + bytes(v); used[k] = 1
                else: raise ValueError(t)
            body += vu(0)
        hdr = bytearray(b'RIVE') + vu(7) + vu(5) + vu(0)
        keys = sorted(used)
        for k in keys: hdr += vu(k)
        hdr += vu(0)
        for i in range(0, len(keys), 4):
            w = 0
            for j, k in enumerate(keys[i:i + 4]): w |= used[k] << (j * 2)
            hdr += struct.pack('<I', w)
        open(path, 'wb').write(hdr + body)


def start(artboard):
    r = Riv()
    r.add('Backboard')
    r.add('ViewModel', name='GettingStarted')
    r.add('ViewModelPropertyBoolean', name='reduceMotion')
    r.add('ViewModelInstance', viewModelId=0, name='Instance')
    r.add('ViewModelInstanceBoolean', v5=0, viewModelPropertyId=0)
    r.comp('art', 'Artboard', name=artboard, width=W, height=H,
           defaultStateMachineId=0, viewModelId=0, clip=True)
    r.node('root', 'art', name='Scene')
    return r


def pop(r, h, t0, t_out=None, dur=0.25, over=1.15, base=0.001):
    """Scale `h` from nothing to 1 with overshoot at t0; shrink back at t_out."""
    t_out = t_out or DUR - 0.3
    seq = [(0, base), (t0, base), (t0 + dur * 0.7, over), (t0 + dur, 1.0),
           (t_out, 1.0), (t_out + 0.2, base), (DUR, base)]
    r.key(h, 'scaleX', seq); r.key(h, 'scaleY', seq)


def fade(r, h, t0, t_out=None, dur=0.2):
    t_out = t_out or DUR - 0.3
    r.key(h, 'opacity', [(0, 0.0), (t0, 0.0), (t0 + dur, 1.0), (t_out, 1.0), (t_out + 0.2, 0.0), (DUR, 0.0)])


def grow(r, h, t0, dur=0.35, t_out=None):
    t_out = t_out or DUR - 0.3
    r.key(h, 'scaleX', [(0, 0.001), (t0, 0.001), (t0 + dur, 1.0), (t_out, 1.0), (t_out + 0.2, 0.001), (DUR, 0.001)])


def bob(r, h, prop, base, amp, periods=1, phase=0.0):
    steps = 12 * periods
    r.key(h, prop, [(DUR * i / steps, base + amp * math.sin(2 * math.pi * (periods * i / steps) + phase))
                    for i in range(steps + 1)])


def twinkle(r, h, t0, period=1.0):
    seq = [(0, 0.0)]
    t = t0
    while t + period <= DUR:
        seq += [(t, 0.0), (t + period / 2, 1.0), (t + period, 0.0)]
        t += period
    seq.append((DUR, 0.0))
    clean = []
    for t, v in seq:
        if clean and abs(clean[-1][0] - t) < 1e-9: continue
        clean.append((t, v))
    r.key(h, 'opacity', clean)
    sc = [(t, 0.4 + 0.6 * v) for t, v in clean]
    r.key(h, 'scaleX', sc); r.key(h, 'scaleY', sc)


def sparkle(r, h, parent, x, y, col, size=10):
    s = size
    r.node(h, parent, x=x, y=y, opacity=0)
    r.poly(h + '_s', h, [(0, -s), (s * 0.25, -s * 0.25), (s, 0), (s * 0.25, s * 0.25),
                          (0, s), (-s * 0.25, s * 0.25), (-s, 0), (-s * 0.25, -s * 0.25)], col)


def check_badge(r, h, parent, x, y, size=44):
    r.node(h, parent, x=x, y=y, scaleX=0.001, scaleY=0.001)
    k = size / 44
    r.poly(h + '_check', h, [(-12 * k, 0), (-7 * k, -5 * k), (-3 * k, -1 * k), (8 * k, -12 * k),
                             (13 * k, -7 * k), (-3 * k, 9 * k)], CARD_DARK)
    r.ellipse(h + '_disc', h, 0, 0, size, size, GREEN)


# ======================================================================= scenes

def github_account():
    """A new developer profile card fills in, then gets a green check."""
    r = start('GithubAccount')
    CX, CY = 240, 140
    for i, (x, y, col, t0) in enumerate([(120, 60, LIME, 0.2), (372, 74, PURPLE, 0.7), (352, 214, CYAN, 1.2), (98, 200, AMBER, 1.7)]):
        sparkle(r, f'sp{i}', 'root', x, y, col)
        twinkle(r, f'sp{i}', t0)
    check_badge(r, 'check', 'root', CX + 104, CY - 62)
    pop(r, 'check', 1.55)
    r.node('card', 'root', x=CX, y=CY)
    # avatar
    r.node('avatar', 'card', x=-66, y=-20, scaleX=0.001, scaleY=0.001)
    r.ellipse('avatar_head', 'avatar', 0, -8, 22, 22, CARD_DARK)
    r.poly('avatar_body', 'avatar', [(-18, 22), (-14, 10), (-6, 5), (6, 5), (14, 10), (18, 22)], CARD_DARK)
    r.ellipse('avatar_disc', 'avatar', 0, 0, 64, 64, PURPLE)
    pop(r, 'avatar', 0.15)
    # form lines
    for i, (y, w, col, t0) in enumerate([(-38, 96, WHITE, 0.45), (-14, 120, SOFT, 0.7), (10, 80, SOFT, 0.95)]):
        r.bar(f'line{i}', 'card', -20, y, w, 10, col)
        grow(r, f'line{i}', t0)
    # button
    r.node('btn', 'card', x=34, y=46, opacity=0)
    r.rect('btn_r', 'btn', 0, 0, 108, 26, GREEN, r=13)
    fade(r, 'btn', 1.2)
    r.rect('card_bg', 'card', 0, 0, 240, 150, CARD, r=18, line=LINE, thick=2)
    bob(r, 'card', 'y', CY, 4)
    r.finish('GithubAccount', still_at=2.2)
    return r


def codespace():
    """A cloud beams a ready-to-code editor window down to the student."""
    r = start('Codespace')
    for i, (x, y, col, t0) in enumerate([(70, 70, CYAN, 0.3), (410, 60, PURPLE, 1.0), (420, 220, LIME, 1.8)]):
        sparkle(r, f'sp{i}', 'root', x, y, col, 9)
        twinkle(r, f'sp{i}', t0)
    # beam dots falling from cloud to window
    for i in range(3):
        h = f'dot{i}'
        r.node(h, 'root', x=240, y=92, opacity=0)
        r.ellipse(h + '_s', h, 0, 0, 8, 8, CYAN)
        t0 = 0.1 + i * 0.3
        r.key(h, 'y', [(0, 92), (t0, 92), (t0 + 0.45, 136), (DUR, 136)])
        r.key(h, 'opacity', [(0, 0.0), (t0, 0.0), (t0 + 0.1, 1.0), (t0 + 0.4, 1.0), (t0 + 0.45, 0.0), (DUR, 0.0)])
    # cloud
    r.node('cloud', 'root', x=240, y=62)
    for i, (x, y, w, hh) in enumerate([(-30, 8, 56, 40), (0, -4, 66, 56), (32, 8, 52, 38), (0, 14, 110, 30)]):
        r.ellipse(f'cloud{i}', 'cloud', x, y, w, hh, color('BBDEFB'))
    bob(r, 'cloud', 'y', 62, 5)
    # editor window
    r.node('win', 'root', x=240, y=190)
    r.node('content', 'win', opacity=0)
    for i, (y, w, col) in enumerate([(-6, 110, PURPLE), (10, 150, BLUE), (26, 90, GREEN)]):
        r.bar(f'code{i}', 'content', -90, y, w, 8, col)
        grow(r, f'code{i}', 1.75 + i * 0.15, 0.25)
    r.key('content', 'opacity', [(0, 0.0), (1.7, 0.0), (1.8, 1.0), (DUR - 0.3, 1.0), (DUR - 0.1, 0.0), (DUR, 0.0)])
    r.node('progress', 'win', opacity=1)
    r.bar('pbar', 'progress', -90, 10, 180, 10, GREEN)
    r.rect('ptrack', 'progress', 0, 10, 180, 10, LINE, r=5)
    r.key('pbar', 'scaleX', [(0, 0.001), (0.2, 0.001), (1.5, 1.0), (DUR, 1.0)])
    r.key('progress', 'opacity', [(0, 1.0), (1.55, 1.0), (1.7, 0.0), (DUR - 0.1, 0.0), (DUR, 1.0)])
    for i, col in enumerate([RED, AMBER, GREEN]):
        r.ellipse(f'wdot{i}', 'win', -104 + i * 14, -38, 8, 8, col)
    r.rect('win_bar', 'win', 0, -38, 240, 1.5, LINE)
    r.rect('win_bg', 'win', 0, 0, 240, 100, CARD, r=14, line=LINE, thick=2)
    r.finish('Codespace', still_at=2.4)
    return r


def vscode():
    """An editor where colorful lines of code type themselves in."""
    r = start('VsCode')
    for i, (x, y, col, t0) in enumerate([(66, 56, BLUE, 0.4), (418, 214, TEAL, 1.4)]):
        sparkle(r, f'sp{i}', 'root', x, y, col, 9)
        twinkle(r, f'sp{i}', t0)
    r.node('win', 'root', x=240, y=138)
    lines = [(-50, 0, 70, PURPLE), (-30, 16, 120, BLUE), (-10, 32, 90, GREEN), (10, 32, 130, AMBER),
             (30, 16, 60, PURPLE), (50, 0, 40, BLUE)]
    t = 0.2
    cursor_x, cursor_y = [(0, -70 + 0)], [(0, -50.0)]
    for i, (y, indent, w, col) in enumerate(lines):
        x0 = -70 + indent
        r.bar(f'code{i}', 'win', x0, y, w, 8, col)
        grow(r, f'code{i}', t, 0.28)
        t += 0.32
    # blinking cursor that walks down the lines
    r.node('cursor', 'win', x=-70, y=-50)
    r.rect('cursor_r', 'cursor', 0, 0, 3, 14, WHITE)
    cx, cy = [(0, -70.0)], [(0, -50.0)]
    t = 0.2
    for y, indent, w, col in lines:
        x0 = -70 + indent
        cx += [(t, x0), (t + 0.28, x0 + w + 4)]
        cy += [(t, y), (t + 0.28, y)]
        t += 0.32
    cx += [(DUR - 0.3, cx[-1][1]), (DUR, -70.0)]
    cy += [(DUR - 0.3, cy[-1][1]), (DUR, -50.0)]
    r.key('cursor', 'x', cx); r.key('cursor', 'y', cy)
    r.key('cursor', 'opacity', [(0, 1.0), (2.3, 1.0), (2.4, 0.0), (2.5, 1.0), (2.6, 0.0), (2.7, 1.0), (DUR, 1.0)])
    # line numbers + sidebar
    for i, (y, *_rest) in enumerate(lines):
        r.rect(f'ln{i}', 'win', -92, y, 8, 6, FAINT, r=2)
    r.rect('sidebar_icon0', 'win', -134, -40, 14, 14, BLUE, r=3)
    r.rect('sidebar_icon1', 'win', -134, -14, 14, 14, FAINT, r=3)
    r.rect('sidebar_icon2', 'win', -134, 12, 14, 14, FAINT, r=3)
    r.rect('sidebar', 'win', -134, 0, 32, 150, CARD_DARK, r=0)
    r.rect('win_bg', 'win', 0, 0, 300, 150, CARD, r=16, line=LINE, thick=2)
    r.finish('VsCode', still_at=2.2)
    return r


def file_structure():
    """A folder opens and its files hop out one after another."""
    r = start('FileStructure')
    files = [(300, 70, BLUE, 0.3), (340, 135, GREEN, 0.7), (300, 200, PURPLE, 1.1)]
    for i, (x, y, col, t0) in enumerate(files):
        h = f'file{i}'
        r.node(h, 'root', x=170, y=150, opacity=0, scaleX=0.4, scaleY=0.4)
        r.rect(h + '_bar1', h, 6, 2, 30, 5, color('FFFFFF', 110), r=2.5)
        r.rect(h + '_bar0', h, 6, -10, 30, 5, color('FFFFFF', 180), r=2.5)
        r.rect(h + '_tag', h, -24, 0, 12, 34, col, r=3)
        r.rect(h + '_bg', h, 0, 0, 68, 44, CARD, r=10, line=col, thick=2)
        r.key(h, 'x', [(0, 170.0), (t0, 170.0), (t0 + 0.45, x), (DUR - 0.35, x), (DUR - 0.05, 170.0), (DUR, 170.0)])
        r.key(h, 'y', [(0, 150.0), (t0, 150.0), (t0 + 0.25, y - 26), (t0 + 0.45, y), (DUR - 0.35, y), (DUR - 0.05, 150.0), (DUR, 150.0)])
        r.key(h, 'opacity', [(0, 0.0), (t0, 0.0), (t0 + 0.1, 1.0), (DUR - 0.2, 1.0), (DUR - 0.05, 0.0), (DUR, 0.0)])
        sc = [(0, 0.4), (t0, 0.4), (t0 + 0.45, 1.0), (DUR - 0.35, 1.0), (DUR - 0.05, 0.4), (DUR, 0.4)]
        r.key(h, 'scaleX', sc); r.key(h, 'scaleY', sc)
    # folder: front flap tilts open
    r.node('folder', 'root', x=150, y=150)
    r.node('flap', 'folder', x=-60, y=40)
    r.poly('flap_s', 'flap', [(0, 0), (0, -64), (120, -64), (120, 0)], AMBER)
    r.key('flap', 'scaleY', [(0, 1.0), (0.15, 1.0), (0.35, 0.72), (DUR - 0.4, 0.72), (DUR - 0.15, 1.0), (DUR, 1.0)])
    r.poly('folder_back', 'folder', [(-60, 40), (-60, -46), (-20, -46), (-10, -34), (60, -34), (60, 40)], ORANGE)
    bob(r, 'folder', 'y', 150, 3)
    r.finish('FileStructure', still_at=2.0)
    return r


def run_game():
    """Press play: a little hero hops by a campfire in a game window."""
    r = start('RunGame')
    for i, (x, y, col, t0) in enumerate([(84, 40, AMBER, 0.2), (400, 36, CYAN, 0.9), (60, 230, LIME, 1.6)]):
        sparkle(r, f'sp{i}', 'root', x, y, col, 8)
        twinkle(r, f'sp{i}', t0)
    r.node('win', 'root', x=240, y=138)
    # play button that presses, then fades
    r.node('play', 'win', x=0, y=0)
    r.poly('play_tri', 'play', [(-9, -13), (15, 0), (-9, 13)], CARD_DARK)
    r.ellipse('play_disc', 'play', 0, 0, 56, 56, GREEN)
    r.key('play', 'scaleX', [(0, 1.0), (0.25, 0.85), (0.4, 1.1), (0.6, 0.001), (DUR - 0.2, 0.001), (DUR, 1.0)])
    r.key('play', 'scaleY', [(0, 1.0), (0.25, 0.85), (0.4, 1.1), (0.6, 0.001), (DUR - 0.2, 0.001), (DUR, 1.0)])
    r.node('game', 'win', opacity=0)
    r.key('game', 'opacity', [(0, 0.0), (0.5, 0.0), (0.7, 1.0), (DUR - 0.25, 1.0), (DUR - 0.05, 0.0), (DUR, 0.0)])
    # hero: hops twice while walking right then back
    r.node('hero', 'game', x=-80, y=36)
    r.rect('hero_eye', 'hero', 5, -4, 4, 6, CARD_DARK)
    r.rect('hero_body', 'hero', 0, 0, 22, 26, BLUE, r=6)
    hx = [(0, -80.0), (0.7, -80.0), (1.6, 10.0), (2.5, -80.0), (DUR, -80.0)]
    r.key('hero', 'x', hx)
    r.key('hero', 'y', [(0, 36.0), (0.8, 36.0), (1.0, 6.0), (1.2, 36.0), (1.8, 36.0), (2.0, 6.0), (2.2, 36.0), (DUR, 36.0)])
    # campfire
    r.node('fire', 'game', x=70, y=42)
    r.node('flame', 'fire', x=0, y=0)
    r.poly('flame_in', 'flame', [(-5, 0), (0, -14), (5, 0)], AMBER)
    r.poly('flame_out', 'flame', [(-10, 0), (-4, -14), (0, -26), (4, -14), (10, 0)], ORANGE)
    flick = [(i * DUR / 12, 1.0 + (0.18 if i % 2 else -0.1)) for i in range(12)] + [(DUR, 0.9)]
    flick[0] = (0, 0.9)
    r.key('flame', 'scaleY', flick)
    r.rect('log0', 'fire', 0, 3, 28, 6, color('8D6E63'), r=3, rotation=0.25)
    r.rect('log1', 'fire', 0, 3, 28, 6, color('6D4C41'), r=3, rotation=-0.25)
    # stars + ground
    for i, (x, y) in enumerate([(-110, -40), (-30, -52), (60, -36), (120, -50)]):
        r.ellipse(f'star{i}', 'game', x, y, 4, 4, color('FFFFFF', 160))
    r.rect('ground', 'game', 0, 56, 300, 14, color('2E7D32'))
    r.rect('win_bg', 'win', 0, 0, 300, 140, color('1A1F3A'), r=16, line=LINE, thick=2)
    r.finish('RunGame', still_at=1.6)
    return r


SCENES = {
    'gs_github_account': github_account,
    'gs_codespace': codespace,
    'gs_vscode': vscode,
    'gs_file_structure': file_structure,
    'gs_run_game': run_game,
}

if __name__ == '__main__':
    out = sys.argv[1] if len(sys.argv) > 1 else 'assets/rive'
    os.makedirs(out, exist_ok=True)
    for name, build in SCENES.items():
        r = build()
        path = os.path.join(out, name + '.riv')
        r.write(path)
        print(name, len(r.objs), 'objects', os.path.getsize(path), 'bytes')
