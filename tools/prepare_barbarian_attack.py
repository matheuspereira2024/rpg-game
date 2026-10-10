from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage

from prepare_barbarian_walk import remove_connected_checkerboard


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "assets" / "sprites" / "humano" / "animations" / "sources" / "barbaro-ataque-basico-direita-v1-raw.png"
OUTPUTS = (
    ROOT / "assets" / "sprites" / "humano" / "animations" / "barbaro-ataque-basico-direita-v1-spaced-v1.png",
    ROOT / "invocacao-web" / "public" / "art" / "arena" / "heroes" / "humano" / "animations" / "barbaro-ataque-basico-direita-v1-spaced-v1.png",
)

FRAME_BOUNDS = (0, 300, 620, 930, 1390, 1866, 2172)
FRAME_WIDTH = 500
FRAME_HEIGHT = 724
GROUND_Y = 557


def keep_components(frame: Image.Image, amount: int) -> Image.Image:
    alpha = np.asarray(frame.getchannel("A")) > 0
    labels, count = ndimage.label(alpha)
    if count < amount:
        raise RuntimeError("Um quadro do ataque perdeu componentes esperados.")

    sizes = np.bincount(labels.ravel())
    selected = np.argsort(sizes[1:])[-amount:] + 1
    cleaned_alpha = np.where(np.isin(labels, selected), 255, 0).astype(np.uint8)
    result = frame.copy()
    result.putalpha(Image.fromarray(cleaned_alpha, "L"))
    return result


def trim_outer_light_fringe(frame: Image.Image) -> Image.Image:
    rgba = np.asarray(frame).copy()
    alpha = rgba[:, :, 3] > 0
    boundary = alpha & ~ndimage.binary_erosion(alpha)
    rgb = rgba[:, :, :3]
    neutral = (rgb.max(axis=2) - rgb.min(axis=2)) <= 14
    light = rgb.min(axis=2) >= 150
    rgba[boundary & neutral & light, 3] = 0
    rgba[GROUND_Y:, :, 3] = 0

    cleaned_alpha = rgba[:, :, 3] > 0
    outer_edge = cleaned_alpha & ~ndimage.binary_erosion(cleaned_alpha)
    rgba[outer_edge, :3] = (24, 18, 20)
    return Image.fromarray(rgba, "RGBA")


def apply_shared_palette(sheet: Image.Image, colors: int = 48) -> Image.Image:
    rgba = np.asarray(sheet)
    foreground = rgba[:, :, :3][rgba[:, :, 3] > 0]
    sample = Image.fromarray(foreground.reshape(1, -1, 3), "RGB")
    palette = sample.quantize(colors=colors, method=Image.Quantize.MEDIANCUT)
    quantized = sheet.convert("RGB").quantize(palette=palette, dither=Image.Dither.NONE).convert("RGBA")
    quantized.putalpha(sheet.getchannel("A"))
    return quantized


def main() -> None:
    cleaned = remove_connected_checkerboard(Image.open(RAW))
    sheet = Image.new("RGBA", (FRAME_WIDTH * 11, FRAME_HEIGHT), (0, 0, 0, 0))

    for index, (left, right) in enumerate(zip(FRAME_BOUNDS, FRAME_BOUNDS[1:])):
        component_count = 2 if index == 3 else 1
        frame = keep_components(cleaned.crop((left, 0, right, FRAME_HEIGHT)), component_count)
        frame = trim_outer_light_fringe(frame)
        canvas = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (0, 0, 0, 0))
        canvas.alpha_composite(frame, ((FRAME_WIDTH - frame.width) // 2, 0))
        sheet.alpha_composite(canvas, (index * FRAME_WIDTH * 2, 0))

    sheet = apply_shared_palette(sheet)

    for output in OUTPUTS:
        output.parent.mkdir(parents=True, exist_ok=True)
        sheet.save(output, optimize=True)
        print(output.relative_to(ROOT))


if __name__ == "__main__":
    main()
