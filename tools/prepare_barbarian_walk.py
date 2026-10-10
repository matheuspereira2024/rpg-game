from pathlib import Path

import numpy as np
from PIL import Image
from scipy import ndimage


ROOT = Path(__file__).resolve().parents[1]
RAW = ROOT / "assets" / "sprites" / "humano" / "animations" / "sources" / "barbaro-walk-direita-v1-raw.png"
OUTPUTS = (
    ROOT / "assets" / "sprites" / "humano" / "animations" / "barbaro-walk-direita-v1-spaced-v1.png",
    ROOT / "invocacao-web" / "public" / "art" / "arena" / "heroes" / "humano" / "animations" / "barbaro-walk-direita-v1-spaced-v1.png",
)

FRAME_BOUNDS = (0, 322, 631, 927, 1241, 1565, 1866, 2172)
FRAME_WIDTH = 330
FRAME_HEIGHT = 724


def remove_connected_checkerboard(image: Image.Image) -> Image.Image:
    rgb = np.asarray(image.convert("RGB"))
    channel_max = rgb.max(axis=2)
    channel_min = rgb.min(axis=2)
    # O fundo gerado é cinza claro e quase neutro.Exception. A remoção só alcança
    # pixels conectados às bordas, portanto peles e metal cercados pelo contorno
    # escuro do personagem não são tratados como fundo.
    passable = ((channel_max - channel_min) <= 24) & (channel_min >= 145)
    seeds = np.zeros(passable.shape, dtype=bool)
    seeds[0, :] = passable[0, :]
    seeds[-1, :] = passable[-1, :]
    seeds[:, 0] = passable[:, 0]
    seeds[:, -1] = passable[:, -1]
    background = ndimage.binary_propagation(seeds, mask=passable)

    rgba = np.dstack((rgb, np.where(background, 0, 255).astype(np.uint8)))
    return Image.fromarray(rgba, "RGBA")


def keep_primary_component(frame: Image.Image) -> Image.Image:
    alpha = np.asarray(frame.getchannel("A")) > 0
    labels, count = ndimage.label(alpha)
    if count == 0:
        raise RuntimeError("Um quadro do Walk ficou vazio após a limpeza.")
    sizes = np.bincount(labels.ravel())
    primary = 1 + np.argmax(sizes[1:])
    cleaned_alpha = np.where(labels == primary, 255, 0).astype(np.uint8)
    result = frame.copy()
    result.putalpha(Image.fromarray(cleaned_alpha, "L"))
    return result


def main() -> None:
    cleaned = remove_connected_checkerboard(Image.open(RAW))
    sheet = Image.new("RGBA", (FRAME_WIDTH * 13, FRAME_HEIGHT), (0, 0, 0, 0))

    for index, (left, right) in enumerate(zip(FRAME_BOUNDS, FRAME_BOUNDS[1:])):
        frame = keep_primary_component(cleaned.crop((left, 0, right, FRAME_HEIGHT)))
        canvas = Image.new("RGBA", (FRAME_WIDTH, FRAME_HEIGHT), (0, 0, 0, 0))
        canvas.alpha_composite(frame, ((FRAME_WIDTH - frame.width) // 2, 0))
        frame = canvas
        sheet.alpha_composite(frame, (index * FRAME_WIDTH * 2, 0))

    for output in OUTPUTS:
        output.parent.mkdir(parents=True, exist_ok=True)
        sheet.save(output, optimize=True)
        print(output.relative_to(ROOT))


if __name__ == "__main__":
    main()
