"""Hand-drawn 32x32 wizard sprite sheets matching the shark set's layout.

Usage: python3 generate_wizard.py <out_dir> [preview_dir]  (needs Pillow)
"""
import math, os, sys
from PIL import Image, ImageOps

OUT = sys.argv[1]
PREVIEW = sys.argv[2] if len(sys.argv) > 2 else OUT
S = 32
OUTLINE = (27, 31, 46)
P = {
    'robe': (90, 61, 153), 'robe_d': (60, 40, 112), 'robe_l': (124, 96, 196),
    'gold': (224, 180, 74), 'gold_l': (247, 220, 120),
    'skin': (240, 195, 155), 'skin_d': (205, 150, 115),
    'beard': (236, 241, 245), 'beard_d': (182, 192, 206),
    'eye': (27, 31, 46),
    'wood': (122, 74, 38), 'wood_l': (160, 104, 56),
    'orb': (79, 214, 255), 'orb_l': (210, 248, 255), 'orb_d': (42, 140, 196),
    'glow': (160, 235, 255),
    'boot': (74, 47, 31), 'boot_l': (110, 72, 46),
    'belt': (107, 68, 40),
    'dust': (210, 214, 222),
}


class C:
    def __init__(self):
        self.px = {}
        self.fx = {}  # un-outlined effects (glow, dust)

    def put(self, x, y, c):
        if 0 <= x < S and 0 <= y < S:
            self.px[(x, y)] = P[c]

    def rect(self, x0, y0, x1, y1, c):
        for y in range(y0, y1 + 1):
            for x in range(x0, x1 + 1):
                self.put(x, y, c)

    def fxput(self, x, y, c):
        if 0 <= x < S and 0 <= y < S:
            self.fx[(x, y)] = P[c]

    def image(self):
        im = Image.new('RGBA', (S, S), (0, 0, 0, 0))
        for (x, y), c in self.px.items():
            im.putpixel((x, y), c + (255,))
        for (x, y), c in self.px.items():
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                p = (x + dx, y + dy)
                if 0 <= p[0] < S and 0 <= p[1] < S and p not in self.px:
                    im.putpixel(p, OUTLINE + (255,))
        for (x, y), c in self.fx.items():
            if im.getpixel((x, y))[3] == 0:
                im.putpixel((x, y), c + (255,))
        return im


def feet(c, back, front, lift_b=0, lift_f=0):
    """back/front = x of each boot's left pixel; boots are 3 wide, 2 tall."""
    for x0, lift in ((back, lift_b), (front, lift_f)):
        y = 29 - lift
        c.rect(x0, y, x0 + 2, y + 1, 'boot')
        c.put(x0 + 2, y, 'boot_l')


def body(c, dy=0, hem=0, flare=0, staff_dx=0, staff_dy=0, glow=0, staff=None, squint=False):
    """staff=None draws the upright staff; staff=(hx, hy, angle, reach) swings it (see swung_staff)."""
    o = dy
    if staff is not None and staff[2] < 0:
        swung_staff(c, *staff)  # tilted back: behind the body
    if staff is None:
        upright_staff(c, 24 + staff_dx, 8 + o + staff_dy, o, staff_dy, glow)
    robe_and_head(c, o, hem, flare, squint)
    if staff is not None and staff[2] >= 0:
        swung_staff(c, *staff)  # forward: in front of the body
    if staff is None:
        arm(c, o, 24 + staff_dx, 20 + o + staff_dy)
    else:
        arm(c, o, staff[0], staff[1], swung=True)


def upright_staff(c, sx, top, o, staff_dy, glow):
    # staff behind the front hand
    for y in range(top, min(31, 29 + o + staff_dy) + 1):
        c.put(sx, y, 'wood')
    for y in range(top, top + 4):
        c.put(sx, y, 'wood_l')
    # prongs + orb
    c.put(sx - 2, top - 1, 'wood'); c.put(sx + 2, top - 1, 'wood')
    c.put(sx - 1, top, 'wood'); c.put(sx + 1, top, 'wood')
    c.rect(sx - 1, top - 4, sx + 1, top - 2, 'orb')
    c.put(sx, top - 5, 'orb'); c.put(sx - 2, top - 3, 'orb'); c.put(sx + 2, top - 3, 'orb')
    c.put(sx - 1, top - 4, 'orb_l'); c.put(sx, top - 4, 'orb_l')
    c.put(sx + 1, top - 2, 'orb_d'); c.put(sx + 2, top - 3, 'orb_d')
    if glow:
        for gx, gy in ((sx - 3, top - 6), (sx + 3, top - 6), (sx - 4, top - 3), (sx + 4, top - 3), (sx, top - 7)):
            c.fxput(gx, gy, 'glow')


def swung_staff(c, hx, hy, angle, reach=15):
    """Staff gripped at (hx, hy), tilted `angle` degrees from upright (+ = forward).
    `reach` is grip-to-orb distance; a shorter reach means the hand slid up the shaft."""
    a = math.radians(angle)
    ux, uy = math.sin(a), -math.cos(a)
    tail = 24 - reach  # the shaft is always 24px long
    for i in range(-2 * tail, 2 * (reach - 3) + 1):
        t = i / 2
        c.put(round(hx + ux * t), round(hy + uy * t), 'wood_l' if t > reach - 7 else 'wood')
    orb(c, round(hx + ux * reach), round(hy + uy * reach))


def orb(c, ox, oy, glow=0):
    for dx in range(-2, 3):
        for dy in range(-2, 3):
            if abs(dx) + abs(dy) <= 2:
                c.put(ox + dx, oy + dy, 'orb')
    c.put(ox - 1, oy - 1, 'orb_l'); c.put(ox, oy - 1, 'orb_l')
    c.put(ox + 1, oy + 1, 'orb_d'); c.put(ox + 2, oy, 'orb_d')
    if glow:
        ring(c, ox, oy, 3 + glow)


def ring(c, ox, oy, r, color='glow', step=45, start=0):
    for deg in range(start, 360 + start, step):
        a = math.radians(deg)
        c.fxput(round(ox + r * math.cos(a)), round(oy + r * math.sin(a)), color)


def robe_and_head(c, o, hem, flare, squint):
    # robe: trapezoid shoulders y=18 to hem y=28
    for y in range(18, 29):
        t = (y - 18) / 10
        x0 = round(11 - 3 * t) - (flare if y > 24 else 0)
        x1 = round(19 + 3 * t) + (flare if y > 24 else 0)
        sh = hem if y >= 26 else 0
        for x in range(x0 + sh, x1 + 1 + sh):
            c.put(x, y + o, 'robe')
        c.put(x0 + sh, y + o, 'robe_d'); c.put(x0 + sh + 1, y + o, 'robe_d')
        c.put(x1 + sh - 1, y + o, 'robe_l')
    # hem trim
    for x in range(8 + hem - flare, 23 + hem + flare):
        c.put(x, 28 + o, 'gold')
    # belt
    for x in range(10, 22):
        c.put(x, 23 + o, 'belt')
    c.rect(17, 23 + o, 18, 23 + o, 'gold')

    # back hair, face
    c.rect(11, 12 + o, 13, 17 + o, 'beard_d')
    c.rect(13, 12 + o, 20, 17 + o, 'skin')
    c.rect(13, 12 + o, 14, 16 + o, 'skin_d')
    c.put(21, 15 + o, 'skin')  # nose
    c.put(21, 14 + o, 'skin')
    if squint:
        c.put(17, 14 + o, 'eye'); c.put(18, 14 + o, 'eye')
    else:
        c.put(18, 14 + o, 'eye'); c.put(18, 13 + o, 'eye')
    c.put(19, 12 + o, 'beard')  # brow
    c.put(18, 12 + o, 'beard')
    # beard
    beard = [(15, 21, 16), (14, 21, 17), (14, 21, 18), (15, 21, 19), (15, 20, 20), (16, 20, 21), (17, 19, 22), (18, 18, 23)]
    for x0, x1, y in beard:
        for x in range(x0, x1 + 1):
            c.put(x, y + o, 'beard')
        c.put(x0, y + o, 'beard_d')
    c.put(19, 16 + o, 'skin_d')  # mouth hint under moustache
    c.put(20, 16 + o, 'beard'); c.put(21, 16 + o, 'beard')

    # hat: brim y=10..11, cone above, tip bent back
    c.rect(8, 10 + o, 23, 11 + o, 'robe')
    c.rect(8, 11 + o, 23, 11 + o, 'robe_d')
    cone = [(10, 20, 9), (11, 19, 8), (11, 18, 7), (12, 17, 6), (12, 16, 5), (11, 14, 4)]
    for x0, x1, y in cone:
        for x in range(x0, x1 + 1):
            c.put(x, y + o, 'robe')
        c.put(x1, y + o, 'robe_l')
    c.put(10, 4 + o, 'robe'); c.put(9, 5 + o, 'robe'); c.put(8, 6 + o, 'robe_d')
    for x in range(10, 21):
        c.put(x, 9 + o, 'gold')
    c.put(15, 6 + o, 'gold_l'); c.put(14, 7 + o, 'gold_l'); c.put(16, 7 + o, 'gold_l'); c.put(15, 7 + o, 'gold')


def arm(c, o, sx, hy, swung=False):
    # front arm: sleeve from shoulder to hand on staff
    if swung:
        # sleeve follows the hand: 2px thick line from the shoulder
        x0, y0 = 20, 19 + o
        n = max(abs(sx - 1 - x0), abs(hy - y0), 1)
        for i in range(n + 1):
            x = round(x0 + (sx - 1 - x0) * i / n)
            y = round(y0 + (hy - y0) * i / n)
            c.put(x, y, 'robe'); c.put(x, y + 1, 'robe')
            c.put(x, y, 'robe_l')
        c.rect(sx - 1, hy, sx, hy + 1, 'skin')
        c.put(sx + 1, hy, 'skin'); c.put(sx + 1, hy + 1, 'skin_d')
        return
    for x, y in ((19, 19 + o), (20, 19 + o), (20, 20 + o), (21, 20 + o), (22, 20 + o), (21, 21 + o), (22, 21 + o)):
        c.put(x, y, 'robe')
    c.put(20, 20 + o, 'robe_l'); c.put(21, 20 + o, 'robe_l')
    c.rect(sx - 1, hy, sx, hy + 1, 'skin')
    c.put(sx + 1, hy, 'skin'); c.put(sx + 1, hy + 1, 'skin_d')


def frame(dy=0, feet_args=(11, 16), lifts=(0, 0), hem=0, flare=0, staff_dx=0, staff_dy=0, glow=0, dust=False):
    c = C()
    feet(c, *feet_args, *lifts)
    body(c, dy, hem, flare, staff_dx, staff_dy, glow)
    if dust:
        for x, y in ((5, 30), (6, 29), (4, 31), (25, 30), (26, 29), (27, 31)):
            c.fxput(x, y, 'dust')
    return c.image()


def legs_up(c_dy):
    return c_dy


def jumpframe(dy, lift, flare=0, staff_dy=0, glow=0, dust=False, feet_x=(11, 16)):
    c = C()
    feet(c, *feet_x, lift, lift)
    body(c, dy, 0, flare, 0, staff_dy, glow)
    if dust:
        for x, y in ((5, 30), (6, 29), (4, 31), (27, 30), (28, 29), (29, 31)):
            c.fxput(x, y, 'dust')
    return c.image()


def pose(dy=0, hand=(22, 20), angle=0, reach=15, hem=0, flare=0, squint=False, feet_args=(11, 16)):
    c = C()
    feet(c, *feet_args)
    body(c, dy, hem, flare, staff=(hand[0], hand[1] + dy, angle, reach), squint=squint)
    return c


def orb_pos(hand, dy, angle, reach):
    a = math.radians(angle)
    return round(hand[0] + math.sin(a) * reach), round(hand[1] + dy - math.cos(a) * reach)


def melee():
    """Staff smash: crouch and lift, raise high, swing forward, smash with sparks, follow through."""
    out = []
    c = C(); feet(c, 10, 17); body(c, 1, flare=1, staff_dy=-2); out.append(c.image())   # crouch, lift staff
    c = C(); feet(c, 11, 16); body(c, 0, staff_dy=-2, glow=1); out.append(c.image())   # raise high
    c = pose(-1, (21, 17), 35, 13, hem=1)                                               # swing forward
    for deg in range(-10, 30, 6):                                                       # motion trail
        a = math.radians(deg)
        c.fxput(round(20 + math.sin(a) * 15), round(17 - math.cos(a) * 15), 'glow')
    out.append(c.image())
    c = pose(1, (20, 20), 70, 9, hem=1, flare=1, feet_args=(10, 17))                    # smash
    ox, oy = orb_pos((20, 20), 1, 70, 9)
    for dx, dy in ((0, -4), (2, -3), (-2, -4), (2, 3), (0, 4), (-2, 4)):                # impact sparks
        c.fxput(ox + dx, oy + dy, 'orb_l')
    out.append(c.image())
    out.append(pose(0, (21, 20), 30, 13).image())                                      # follow through
    return out


def ranged():
    """Cast a bolt: raise the staff, charge the orb, thrust and release, recover."""
    out = []
    c = C(); feet(c, 11, 16); body(c, 0, glow=1); out.append(c.image())  # ready
    c = pose(-1, (23, 18), 0, 14)                                        # raise + charge ring
    ring(c, *orb_pos((23, 18), -1, 0, 14), 4, step=45)
    out.append(c.image())
    c = pose(-1, (23, 18), 0, 14)                                        # full charge
    ox, oy = orb_pos((23, 18), -1, 0, 14)
    c.rect(ox - 1, oy - 1, ox + 1, oy + 1, 'orb_l')
    ring(c, ox, oy, 3, step=45, start=22)
    out.append(c.image())
    c = pose(0, (21, 19), 40, 10, hem=1)                                 # thrust, bolt forms
    ox, oy = orb_pos((21, 19), 0, 40, 10)
    c.rect(ox - 1, oy - 1, ox + 1, oy + 1, 'orb_l')
    for dx, dy in ((3, -1), (3, 1), (4, 0), (2, -3), (2, 3)):
        c.fxput(ox + dx, oy + dy, 'glow')
    out.append(c.image())
    c = pose(0, (21, 19), 45, 10, hem=1)                                 # release: bolt leaves
    ox, oy = orb_pos((21, 19), 0, 45, 10)
    bolt_y = oy
    for x in range(ox + 3, 32):
        c.fxput(x, bolt_y, 'glow')
    for dx, dy in ((0, 0), (0, -1), (0, 1), (-1, 0), (1, 0)):
        c.fxput(30 + dx, bolt_y + dy, 'orb_l')
    c.fxput(29, bolt_y - 1, 'orb'); c.fxput(29, bolt_y + 1, 'orb')
    out.append(c.image())
    c = pose(0, (22, 20), 15, 14)                                        # recover, sparkles fade
    ox, oy = orb_pos((22, 20), 0, 15, 14)
    for dx, dy in ((4, -2), (5, 1), (3, 3)):
        c.fxput(ox + dx, oy + dy, 'glow')
    out.append(c.image())
    return out


WHITE, RED = (255, 255, 255), (228, 40, 38)  # same flash/knockback tints as the shark hurt sheet


def tint(im, color, t):
    px = im.load()
    out = im.copy(); po = out.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a:
                po[x, y] = (round(r + (color[0] - r) * t), round(g + (color[1] - g) * t),
                            round(b + (color[2] - b) * t), a)
    return out


def shift(im, dx, dy):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    out.paste(im, (dx, dy))
    return out


def hurt():
    """White flash, red knockback (eyes squeezed), ease back to normal colors."""
    idle0 = frame(0)
    return [
        tint(idle0, WHITE, 0.65),
        shift(tint(pose(1, (22, 20), -15, squint=True).image(), RED, 0.35), -2, 0),
        shift(tint(pose(1, (22, 20), -8, squint=True).image(), RED, 0.25), -1, 0),
        tint(pose(1, (22, 20), -3).image(), RED, 0.12),
        idle0,
    ]


def bolt_frames():
    """16x16 projectile for Bonfire's range attack: pulsing orb with a sparkle trail."""
    out = []
    for i in range(4):
        im = Image.new('RGBA', (16, 16), (0, 0, 0, 0))
        put = lambda x, y, k: im.putpixel((x, y), P[k] + (255,))
        cx, cy = 10, 8
        r = 3 if i % 2 == 0 else 2
        for dx in range(-r - 1, r + 2):
            for dy in range(-r - 1, r + 2):
                d = abs(dx) + abs(dy)
                if d <= r - 1:
                    put(cx + dx, cy + dy, 'orb_l')
                elif d <= r:
                    put(cx + dx, cy + dy, 'orb')
                elif d == r + 1:
                    put(cx + dx, cy + dy, 'orb_d')
        for j, x in enumerate(range(cx - r - 2, 0, -2)):  # trail
            y = cy + ((j + i) % 3) - 1
            put(x, y, 'glow' if j % 2 else 'orb')
        out.append(im)
    return out


anims = {
    'idle': [frame(0, glow=0), frame(0, glow=1), frame(1, glow=1), frame(1, glow=0)],
    'walk': [
        frame(0, (9, 18), hem=1, staff_dx=1),
        frame(-1, (12, 15), (1, 0), hem=0),
        frame(0, (10, 17), (0, 0), hem=-1, staff_dx=0),
        frame(-1, (13, 14), (0, 1), hem=0),
    ],
    'jump': [
        jumpframe(2, 0, flare=1, dust=False, feet_x=(10, 17)),       # crouch
        jumpframe(-1, 1, flare=0, staff_dy=-1),                       # take off
        jumpframe(-2, 2, flare=1, staff_dy=0, glow=1),               # rise
        jumpframe(-2, 3, flare=1, staff_dy=0, glow=1),               # peak
        jumpframe(-1, 1, flare=0),                                    # fall
        jumpframe(1, 0, flare=1, dust=True, feet_x=(10, 17)),         # land
    ],
    'attack_melee': melee(),
    'attack_range': ranged(),
    'hurt': hurt(),
}


def save_sheet(name, frames, size=S):
    right = Image.new('RGBA', (size * len(frames), size), (0, 0, 0, 0))
    left = right.copy()
    for i, f in enumerate(frames):
        right.paste(f, (i * size, 0))
        left.paste(ImageOps.mirror(f), (i * size, 0))
    right.save(f'{OUT}/wizard_{name}_right.png')
    left.save(f'{OUT}/wizard_{name}_left.png')


os.makedirs(OUT, exist_ok=True)
for name, frames in anims.items():
    save_sheet(name, frames)
save_sheet('magic_bolt', bolt_frames(), 16)

# 4x preview: right rows then left rows
rows = []
for side in ('right', 'left'):
    for name in anims:
        rows.append(Image.open(f'{OUT}/wizard_{name}_{side}.png'))
pw = max(r.width for r in rows)
prev = Image.new('RGBA', (pw, S * len(rows)), (0, 0, 0, 0))
for i, r in enumerate(rows):
    prev.paste(r, (0, i * S))
prev.resize((pw * 4, prev.height * 4), Image.NEAREST).save(f'{PREVIEW}/wizard_preview_4x.png')
