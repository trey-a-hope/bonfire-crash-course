"""Builds one Excalidraw diagram per course module from tool/diagrams/specs/*.json.

Layout (approved on Module 3): module title + badge, the module box, one column per
lesson with its key concepts, then "What students finish with" (the completion page
achievements). Build steps and pro tips are left out on purpose.

Usage: python3 tool/diagrams/build_module_diagrams.py
Writes docs/module_diagrams/module_<n>_<slug>.excalidraw (one per module),
docs/module_diagrams/bonfire_modules_all.excalidraw (every module in its own frame),
docs/module_diagrams/svg/module_<n>_<slug>.svg (inline preview), and
assets/images/module_diagrams/module_<n>_<slug>.svg (the copy the app shows on each
module's section of the Content Outline page, with styles inlined for flutter_svg). A spec's
"overview_page" key keeps its old name: false means no app copy or Content Outline section.
"""
import glob, json, math, os, random, re

ROOT = os.path.dirname(os.path.abspath(__file__))
REPO = os.path.dirname(os.path.dirname(ROOT))
OUT = os.path.join(REPO, 'docs', 'module_diagrams')
APP_OUT = os.path.join(REPO, 'assets', 'images', 'module_diagrams')

COL_W, GAP, BOX_H, MAX_COLS = 330, 20, 50, 3
COLORS = {  # svg class -> (excalidraw fill, stroke)
    'c-amber': ('#ffd8a8', '#f59e0b'), 'c-blue': ('#a5d8ff', '#4a9eed'),
    'c-green': ('#b2f2bb', '#22c55e'),
}


def layout(spec):
    """Returns (width, height, boxes, texts, arrows) in 1x units."""
    lessons = [l for l in spec['lessons'] if l.get('concepts')]
    cols = max(1, min(MAX_COLS, len(lessons)))
    outcomes = spec.get('outcomes', [])
    # Outcomes sit in rows of 3 only when that leaves no lone box (5 -> 3 + 2); otherwise rows of 2.
    ocols = 3 if cols == 3 and len(outcomes) % 3 != 1 else 2
    span = max(cols, min(ocols, len(outcomes)))
    width = 20 * 2 + span * COL_W + (span - 1) * GAP
    cx = width / 2
    boxes, texts, arrows = [], [], []
    badge = f" (badge: {spec['badge']})" if spec.get('badge') else ''
    texts.append((cx, 22, f"Module {spec['number']}: {spec['name']}{badge}", 'th', 'middle'))
    boxes.append((cx - 125, 38, 250, 44, 'c-amber', spec['name'], spec['tagline'], True))
    y_row, bottoms = 108, []
    for start in range(0, len(lessons), cols):
        row = lessons[start:start + cols]
        row_w = len(row) * COL_W + (len(row) - 1) * GAP
        x0 = cx - row_w / 2
        row_bottom = y_row
        bottoms = []  # only the last row's columns point down to the outcomes
        for i, lesson in enumerate(row):
            x = x0 + i * (COL_W + GAP)
            if start == 0:
                arrows.append((cx + (i - (len(row) - 1) / 2) * 60, 82, x + COL_W / 2, y_row - 2, False))
            boxes.append((x, y_row, COL_W, 46, 'c-blue', f"Lesson {lesson['number']}: {lesson['title']}", lesson['summary'], True))
            y = y_row + 64
            texts.append((x, y + 4, 'KEY CONCEPTS', 'ts', 'start'))
            y += 12
            for title, sub in lesson['concepts']:
                boxes.append((x, y, COL_W, BOX_H, 'c-amber', title, sub, False))
                y += BOX_H + 8
            bottoms.append((x + COL_W / 2, y - 8))
            row_bottom = max(row_bottom, y - 8)
        y_row = row_bottom + 30
    y = y_row
    if outcomes:
        y += 6
        for bx, by in bottoms:
            arrows.append((bx, by, bx, y - 2, True))
        texts.append((cx, y + 16, 'WHAT STUDENTS FINISH WITH', 'ts', 'middle'))
        y += 28
        for start in range(0, len(outcomes), ocols):
            row = outcomes[start:start + ocols]
            row_w = len(row) * COL_W + (len(row) - 1) * GAP
            for i, (title, sub) in enumerate(row):
                boxes.append((cx - row_w / 2 + i * (COL_W + GAP), y, COL_W, BOX_H, 'c-green', title, sub, True))
            y += BOX_H + 8
    return width, y + 12, boxes, texts, arrows


def to_svg(spec):
    w, h, boxes, texts, arrows = layout(spec)
    o = [f'<svg viewBox="0 0 {w:.0f} {h:.0f}" xmlns="http://www.w3.org/2000/svg"><defs><marker id="ah" viewBox="0 0 10 10" refX="9" refY="5" markerWidth="7" markerHeight="7" orient="auto-start-reverse"><path d="M0,0 L10,5 L0,10 z" fill="none" stroke="context-stroke" stroke-width="1.5"/></marker></defs>']
    for x1, y1, x2, y2, dash in arrows:
        o.append(f'<line class="arr" x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" marker-end="url(#ah)"' + (' stroke-dasharray="5 4"' if dash else '') + '/>')
    for x, y, t, c, a in texts:
        o.append(f'<text class="{c}" x="{x:.0f}" y="{y:.0f}" text-anchor="{a}">{esc(t)}</text>')
    for x, y, bw, bh, c, t, s, center in boxes:
        tx, a = (x + bw / 2, 'middle') if center else (x + 12, 'start')
        o.append(f'<g class="{c}"><rect x="{x:.0f}" y="{y:.0f}" width="{bw}" height="{bh}" rx="8"/><text class="th" x="{tx:.0f}" y="{y + 20:.0f}" text-anchor="{a}">{esc(t)}</text><text class="ts" x="{tx:.0f}" y="{y + 39:.0f}" text-anchor="{a}">{esc(s)}</text></g>')
    o.append('</svg>')
    return ''.join(o)


# Standalone files need their own colors; drop this <style> when posting the SVG as a chat widget,
# which supplies the c-*/th/ts/arr classes itself.
SVG_STYLE = ('<style>rect{stroke-width:1.5}.th{font:600 14px sans-serif;fill:#1e1e1e}.ts{font:12px sans-serif;fill:#555}'
             '.c-amber rect{fill:#fde7c4;stroke:#d97706}.c-blue rect{fill:#dbeafe;stroke:#2563eb}'
             '.c-green rect{fill:#dcfce7;stroke:#16a34a}.arr{stroke:#555;stroke-width:1.5}</style>'
             '<rect width="100%" height="100%" fill="#fff"/>')


# The same colors as SVG_STYLE, written as attributes for the app copy.
APP_FILL = {'c-amber': ('#fde7c4', '#d97706'), 'c-blue': ('#dbeafe', '#2563eb'), 'c-green': ('#dcfce7', '#16a34a')}
APP_FONT = {'th': 'font-size="14" font-weight="600" fill="#1e1e1e"', 'ts': 'font-size="12" fill="#555555"'}


def arrowhead(x1, y1, x2, y2):
    """The marker's triangle as a plain polygon, so the app copy needs no <marker>."""
    d = math.hypot(x2 - x1, y2 - y1)
    ux, uy = (x2 - x1) / d, (y2 - y1) / d
    tip_x, tip_y = x2 + ux * 1.05, y2 + uy * 1.05
    bx, by = tip_x - ux * 10.5, tip_y - uy * 10.5
    pts = [(tip_x, tip_y), (bx - uy * 5.25, by + ux * 5.25), (bx + uy * 5.25, by - ux * 5.25)]
    return ' '.join(f'{px:.1f},{py:.1f}' for px, py in pts)


def to_app_svg(spec):
    """to_svg for the app: plain attributes, with no <style>, classes or <marker>."""
    w, h, boxes, texts, arrows = layout(spec)
    o = [f'<svg viewBox="0 0 {w:.0f} {h:.0f}" width="{w:.0f}" height="{h:.0f}" xmlns="http://www.w3.org/2000/svg">',
         f'<rect width="{w:.0f}" height="{h:.0f}" fill="#ffffff"/>']
    for x1, y1, x2, y2, dash in arrows:
        o.append(f'<line x1="{x1:.0f}" y1="{y1:.0f}" x2="{x2:.0f}" y2="{y2:.0f}" stroke="#555555" stroke-width="1.5"'
                 + (' stroke-dasharray="5 4"' if dash else '') + '/>')
        o.append(f'<polygon points="{arrowhead(x1, y1, x2, y2)}" fill="none" stroke="#555555" stroke-width="1.5"/>')
    for x, y, t, c, a in texts:
        o.append(f'<text x="{x:.0f}" y="{y:.0f}" text-anchor="{a}" font-family="sans-serif" {APP_FONT[c]}>{esc(t)}</text>')
    for x, y, bw, bh, c, t, s, center in boxes:
        fill, stroke = APP_FILL[c]
        tx, a = (x + bw / 2, 'middle') if center else (x + 12, 'start')
        o.append(f'<rect x="{x:.0f}" y="{y:.0f}" width="{bw}" height="{bh}" rx="8" fill="{fill}" stroke="{stroke}" stroke-width="1.5"/>'
                 f'<text x="{tx:.0f}" y="{y + 20:.0f}" text-anchor="{a}" font-family="sans-serif" {APP_FONT["th"]}>{esc(t)}</text>'
                 f'<text x="{tx:.0f}" y="{y + 39:.0f}" text-anchor="{a}" font-family="sans-serif" {APP_FONT["ts"]}>{esc(s)}</text>')
    o.append('</svg>')
    return ''.join(o)


def esc(s):
    return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;')


def el(**kw):
    base = dict(angle=0, strokeColor='#1e1e1e', backgroundColor='transparent', fillStyle='solid', strokeWidth=2,
                strokeStyle='solid', roughness=1, opacity=100, groupIds=[], frameId=None, roundness=None,
                seed=random.randint(1, 2**30), version=1, versionNonce=random.randint(1, 2**30), isDeleted=False,
                boundElements=[], updated=1, link=None, locked=False)
    base.update(kw)
    return base


def text_el(id, x, y, text, fs, color, container=None, align='left', frame=None):
    lines = text.split('\n')
    w, h = max(len(l) for l in lines) * fs * 0.55, len(lines) * fs * 1.25
    if container:
        x, y = x - w / 2, y - h / 2
    return el(type='text', id=id, x=x, y=y, width=w, height=h, text=text, originalText=text, fontSize=fs, fontFamily=1,
              textAlign=align, verticalAlign='middle' if container else 'top', containerId=container, lineHeight=1.25,
              autoResize=True, baseline=round(h - fs * 0.25), strokeColor=color, frameId=frame)


def to_excalidraw(spec, ox=0, oy=0, k=1.5, frame=None, prefix=''):
    w, h, boxes, texts, arrows = layout(spec)
    out = []
    for i, (x, y, t, c, a) in enumerate(texts):
        fs = 24 if c == 'th' else 18
        tw = len(t) * fs * 0.55
        out.append(text_el(f'{prefix}t{i}', ox + x * k - (tw / 2 if a == 'middle' else 0), oy + y * k - fs, t, fs,
                           '#1e1e1e' if c == 'th' else '#757575', frame=frame))
    for i, (x, y, bw, bh, c, t, s, center) in enumerate(boxes):
        bg, st = COLORS[c]
        rid, tid = f'{prefix}b{i}', f'{prefix}b{i}_t'
        out.append(el(type='rectangle', id=rid, x=ox + x * k, y=oy + y * k, width=bw * k, height=bh * k,
                      roundness={'type': 3}, backgroundColor=bg, strokeColor=st, frameId=frame,
                      boundElements=[{'type': 'text', 'id': tid}]))
        out.append(text_el(tid, ox + (x + bw / 2) * k, oy + (y + bh / 2) * k, f'{t}\n{s}', 18, '#1e1e1e',
                           container=rid, align='center', frame=frame))
    for i, (x1, y1, x2, y2, dash) in enumerate(arrows):
        dx, dy = (x2 - x1) * k, (y2 - y1) * k
        out.append(el(type='arrow', id=f'{prefix}a{i}', x=ox + x1 * k, y=oy + y1 * k, width=abs(dx), height=abs(dy),
                      points=[[0, 0], [dx, dy]], startArrowhead=None, endArrowhead='arrow', lastCommittedPoint=None,
                      strokeStyle='dashed' if dash else 'solid', frameId=frame))
    return out, w * k, h * k


def scene(elements):
    return {'type': 'excalidraw', 'version': 2, 'source': 'https://excalidraw.com', 'elements': elements,
            'appState': {'viewBackgroundColor': '#ffffff', 'gridSize': None}, 'files': {}}


def main():
    os.makedirs(os.path.join(OUT, 'svg'), exist_ok=True)
    os.makedirs(APP_OUT, exist_ok=True)
    specs = [json.load(open(p)) for p in sorted(glob.glob(os.path.join(ROOT, 'specs', '*.json')))]
    specs.sort(key=lambda s: s['number'])
    combined, x = [], 0
    for spec in specs:
        slug = re.sub(r'[^a-z0-9]+', '_', spec['name'].lower()).strip('_')
        name = f"module_{spec['number']}_{slug}"
        els, _, _ = to_excalidraw(spec)
        json.dump(scene(els), open(os.path.join(OUT, name + '.excalidraw'), 'w'), indent=1)
        svg = to_svg(spec).replace('</defs>', '</defs>' + SVG_STYLE, 1)
        open(os.path.join(OUT, 'svg', name + '.svg'), 'w').write(svg)
        app_svg = os.path.join(APP_OUT, name + '.svg')
        if spec.get('overview_page', True):
            open(app_svg, 'w').write(to_app_svg(spec))
        elif os.path.exists(app_svg):  # "overview_page": false = no Content Outline section in the app
            os.remove(app_svg)
        fid = f'frame_{spec["number"]}'
        els, w, h = to_excalidraw(spec, ox=x + 40, oy=40, frame=fid, prefix=f'm{spec["number"]}_')
        combined.extend(els)
        combined.append(el(type='frame', id=fid, x=x, y=0, width=w + 80, height=h + 80,
                           name=f"Module {spec['number']}: {spec['name']}", strokeWidth=1, roughness=0))
        x += w + 80 + 200
        print('wrote', name)
    json.dump(scene(combined), open(os.path.join(OUT, 'bonfire_modules_all.excalidraw'), 'w'), indent=1)
    print('wrote bonfire_modules_all')


if __name__ == '__main__':
    main()
