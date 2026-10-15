"""Shark bite, water-spit and hurt sheets, built from the existing 32x32 shark frames.

The shark has no draw script, so new frames are made by editing pixels of its
idle and hurt frames: shifting the body, opening the jaw, tinting, and adding
effect pixels. Usage: python3 generate_shark_combat.py <shark_png_dir> <out_dir> [preview_dir] [svg_dir]  (needs Pillow)
"""
import os, sys
from PIL import Image, ImageOps

SRC, OUT = sys.argv[1], sys.argv[2]
PREVIEW = sys.argv[3] if len(sys.argv) > 3 else OUT
SVG = sys.argv[4] if len(sys.argv) > 4 else OUT
S = 32
OUTLINE = (27, 31, 46)
BODY = (78, 116, 158)
MOUTH = (74, 16, 28)       # inside of the open jaw, darker than the gum red
GUM = (122, 30, 43)
WATER = (64, 164, 230)
WATER_L = (180, 230, 255)
WATER_D = (36, 110, 180)
FOAM = (236, 241, 245)
WHITE, RED = (255, 255, 255), (228, 40, 38)  # tints that reproduce shark_hurt's flash and knockback


def frame(sheet, i):
    return Image.open(f'{SRC}/shark_{sheet}_right.png').convert('RGBA').crop((i * S, 0, i * S + S, S))


IDLE = frame('idle', 0)
HURT_FLASH, HURT_KNOCK = frame('hurt', 0), frame('hurt', 1)


def shift(im, dx, dy):
    out = Image.new('RGBA', im.size, (0, 0, 0, 0))
    out.paste(im, (dx, dy))
    return out


def tint(im, color, t):
    out = im.copy(); px = out.load()
    for y in range(S):
        for x in range(S):
            r, g, b, a = px[x, y]
            if a:
                px[x, y] = (round(r + (color[0] - r) * t), round(g + (color[1] - g) * t),
                            round(b + (color[2] - b) * t), a)
    return out


def squint(im):
    """Eyes squeezed shut: the eye becomes a single dark line."""
    out = im.copy()
    out.putpixel((18, 8), BODY + (255,)); out.putpixel((19, 8), BODY + (255,))
    return out


def open_jaw(im, k):
    """Lift the upper jaw (rows 0-13, right of the hinge at x=15) by k pixels."""
    if k == 0:
        return im.copy()
    src = im.load()
    out = im.copy(); px = out.load()
    for x in range(15, S):
        s = k if x >= 19 else round(k * (x - 15) / 4)
        if s == 0:
            continue
        for y in range(0, 14):
            px[x, y] = (0, 0, 0, 0)
        for y in range(0, 14):
            if y - s >= 0 and src[x, y][3]:
                px[x, y - s] = src[x, y]
        for y in range(14 - s, 14):  # the gap that opened up
            px[x, y] = MOUTH + (255,) if x <= 26 else (0, 0, 0, 0)
    return outline(out)


def outline(im):
    """Re-close the dark outline around any newly exposed edge."""
    out = im.copy(); px = out.load(); src = im.load()
    for y in range(S):
        for x in range(S):
            if src[x, y][3]:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < S and 0 <= ny < S and src[nx, ny][3] and src[nx, ny][:3] != OUTLINE:
                    px[x, y] = OUTLINE + (255,)
                    break
    return out


def fx(im, pts, color):
    """Effect pixels (splash, impact) only land on empty pixels, like the wizard's glow."""
    out = im.copy()
    for x, y in pts:
        if 0 <= x < S and 0 <= y < S and out.getpixel((x, y))[3] == 0:
            out.putpixel((x, y), color + (255,))
    return out


def paint(im, pts, color):
    out = im.copy()
    for x, y in pts:
        if 0 <= x < S and 0 <= y < S:
            out.putpixel((x, y), color + (255,))
    return out


def bite():
    """Crouch, open wide, lunge, chomp with an impact flash, recover."""
    chomp = shift(IDLE, 2, 0)
    chomp = fx(chomp, [(30, 9), (31, 8), (30, 7), (30, 17), (31, 18), (30, 19), (31, 12), (31, 14)], FOAM)
    return [
        shift(squint(IDLE), 0, 1),
        open_jaw(IDLE, 2),
        shift(open_jaw(IDLE, 3), 2, 0),
        chomp,
        shift(IDLE, 1, 0),
    ]


def spit():
    """Inhale, open with water welling up, spit a water ball, spray, recover."""
    welling = paint(open_jaw(IDLE, 2), [(24, 13), (25, 13), (25, 12), (26, 13)], WATER)
    welling = paint(welling, [(25, 12)], WATER_L)
    shot = paint(open_jaw(IDLE, 2), [(x, 13) for x in range(21, 27)] + [(x, 12) for x in range(23, 27)], WATER)
    shot = paint(shot, [(24, 12), (26, 13)], WATER_L)
    shot = shift(shot, 1, 0)
    shot = fx(shot, [(29, 12), (30, 11), (30, 12), (30, 13), (31, 11), (31, 12), (31, 13), (29, 11), (29, 13)], WATER)
    shot = paint(shot, [(30, 11), (31, 12)], WATER_L)
    shot = paint(shot, [(30, 13)], WATER_D)
    spray = shift(open_jaw(IDLE, 1), 1, 0)
    spray = fx(spray, [(29, 12), (31, 11), (30, 14), (31, 13)], WATER)
    spray = fx(spray, [(30, 12), (31, 9)], WATER_L)
    return [
        shift(squint(IDLE), 0, 1),
        welling,
        shot,
        spray,
        IDLE.copy(),
    ]


def hurt():
    """The original flash and knockback frames, then ease back from red to normal."""
    return [
        HURT_FLASH,
        HURT_KNOCK,
        shift(tint(squint(IDLE), RED, 0.25), 0, 1),
        tint(IDLE, RED, 0.12),
        IDLE.copy(),
    ]


def water_ball():
    """16x16 projectile for Bonfire's range attack: wobbling water ball with a spray trail."""
    shapes = [
        ['  ####  ', ' #oooo# ', '#oowwoo#', '#oowooo#', '#ooooo##', ' #oodd# ', '  ####  '],
        ['  ##### ', ' #ooooo#', '#oowwoo#', '#oowooo#', '#ooood# ', ' #oddd# ', '  ####  '],
        ['  ####  ', ' #oooo# ', '#oowwoo#', '#oowooo#', '#ooooo##', ' #oodd# ', '  ####  '],
        [' #####  ', '#ooooo# ', '#oowwoo#', '#oowooo#', ' #ooood#', ' #oddd# ', '  ####  '],
    ]
    cols = {'#': OUTLINE, 'o': WATER, 'w': WATER_L, 'd': WATER_D}
    out = []
    for i, shape in enumerate(shapes):
        im = Image.new('RGBA', (16, 16), (0, 0, 0, 0))
        for y, row in enumerate(shape):
            for x, ch in enumerate(row):
                if ch in cols:
                    im.putpixel((7 + x, 4 + y), cols[ch] + (255,))
        for j, x in enumerate(range(5, 0, -2)):  # spray trail
            y = 7 + ((i + j) % 3)
            im.putpixel((x, y), (WATER_L if j % 2 else WATER) + (255,))
        out.append(im)
    return out


def svg(im, path):
    rects = []
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = im.getpixel((x, y))
            if a:
                rects.append(f'<rect x="{x}" y="{y}" width="1" height="1" fill="#{r:02x}{g:02x}{b:02x}"/>')
    with open(path, 'w') as f:
        f.write(f'<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {im.width} {im.height}" '
                f'width="{im.width * 8}" height="{im.height * 8}" shape-rendering="crispEdges">'
                + ''.join(rects) + '</svg>\n')


def save_sheet(name, frames, size=S):
    right = Image.new('RGBA', (size * len(frames), size), (0, 0, 0, 0))
    left = right.copy()
    for i, f in enumerate(frames):
        right.paste(f, (i * size, 0))
        left.paste(ImageOps.mirror(f), (i * size, 0))
    right.save(f'{OUT}/shark_{name}_right.png')
    left.save(f'{OUT}/shark_{name}_left.png')
    svg(right, f'{SVG}/shark_{name}_right.svg')
    return right, left


os.makedirs(OUT, exist_ok=True)
new = {'attack_bite': bite(), 'attack_range': spit(), 'hurt': hurt()}
sheets = {name: save_sheet(name, frames) for name, frames in new.items()}
save_sheet('water_ball', water_ball(), 16)

# 4x preview of the new sheets: right rows then left rows
rows = [sheets[n][0] for n in new] + [sheets[n][1] for n in new]
pw = max(r.width for r in rows)
prev = Image.new('RGBA', (pw, S * len(rows)), (0, 0, 0, 0))
for i, r in enumerate(rows):
    prev.paste(r, (0, i * S))
prev.resize((pw * 4, prev.height * 4), Image.NEAREST).save(f'{PREVIEW}/shark_combat_preview_4x.png')
