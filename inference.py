import urllib
from PIL import Image
import timm
from timm.data import resolve_data_config
from timm.data.transforms_factory import create_transform
import torch
import json

def run_inferencing(model:str, image:str):
    # To load a pretrained model:
    model = timm.create_model(model, pretrained=True)
    # print(model.eval())
    model.eval()

    # To load and preprocess the image:
    config = resolve_data_config({}, model=model)
    transform = create_transform(**config)

    url, filename = (image, "dog.jpg")
    urllib.request.urlretrieve(url, filename)
    img = Image.open(filename).convert("RGB")
    tensor = transform(img).unsqueeze(0)  # transform and add batch dimension

    url, filename = (
        "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt",
        "imagenet_classes.txt",
    )

    urllib.request.urlretrieve(url, filename)
    with open("imagenet_classes.txt", "r") as f:
        categories = [s.strip() for s in f.readlines()]

    # get model predictions
    with torch.no_grad():
        out = model(tensor)
    probabilities = torch.nn.functional.softmax(out[0], dim=0)

    # Print top categories per image
    top5_prob, top5_catid = torch.topk(probabilities, 5)

    output = []
    for i in range(top5_prob.size(0)):
        output.append(
            dict(
                predicted=categories[top5_catid[i]],
                confidence=round(top5_prob[i].item(), 2),
            )
        )

    output_json = json.dumps(output)
    
    print(output_json)

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', default="cspresnext50", help='model name is a required param.')
    parser.add_argument('--image', default="https://github.com/pytorch/hub/raw/master/images/dog.jpg", help='image name is a required param.')
    args = parser.parse_args()
    # print(f"Using model {args.model} to infer image {args.image}")
    run_inferencing(model=args.model, image=args.image)