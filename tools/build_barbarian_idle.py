from pathlib import Path

from PIL import Image


ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "assets" / "sprites" / "humano" / "barbaro-idle-v1.png"
OUTPUTS = (
    ROOT / "assets" / "sprites" / "humano" / "animations" / "barbaro-idle-semirrelaxado-v1-spaced-v1.png",
    ROOT / "invocacao-web" / "public" / "art" / "arena" / "heroes" / "humano" / "animations" / "barbaro-idle-semirrelaxado-v1-spaced-v1.png",
)

# Seis fases de uma respiração curta. O redimensionamento vertical usa NEAREST e
# mantém a base alfa no mesmo Y, preservando integralmente a arte aprovada.
SCALES = (1.000, 1.002, 1.004, 1.002, 1.000, 0.998)


def anchored_frame(source: Image.Image, scale: float, ground_y: int) -> Image.Image:
    width, height = source.size
    scaled_height = round(height * scale)
    resized = source.resize((width, scaled_height), Image.Resampling.NEAREST)
    scaled_ground = round(ground_y * scale)
    frame = Image.new("RGBA", source.size, (0, 0, 0, 0))
    frame.alpha_composite(resized, (0, ground_y - scaled_ground))
    return frame


def main() -> None:
    source = Image.open(SOURCE).convert("RGBA")
    alpha_box = source.getchannel("A").getbbox()
    if alpha_box is None:
        raise RuntimeError("O Idle aprovado do Bárbaro está vazio.")

    frame_width, frame_height = source.size
    ground_y = alpha_box[3]
    sheet_width = frame_width * (len(SCALES) * 2 - 1)
    sheet = Image.new("RGBA", (sheet_width, frame_height), (0, 0, 0, 0))

    for index, scale in enumerate(SCALES):
        frame = anchored_frame(source, scale, ground_y)
        sheet.alpha_composite(frame, (index * frame_width * 2, 0))

    for output in OUTPUTS:
        output.parent.mkdir(parents=True, exist_ok=True)
        sheet.save(output, optimize=True)
        print(output.relative_to(ROOT))


if __name__ == "__main__":
    main()
