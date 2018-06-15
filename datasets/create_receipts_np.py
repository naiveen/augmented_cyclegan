import os.path
from PIL import Image
import numpy as np
import argparse

# REAL_PATH = "/eai/datasets/ripples/data/real_receipts"
# SYNTH_PATH = "/eai/datasets/whiskey_bear/data/generated/generated_100k_2018may11"
REAL_PATH = "/eai/projects/ripples/data/real_receipts"
SYNTH_PATH = "/eai/projects/whiskey_bear/data/generated/generated_100k_2018may11"

IMG_EXTENSIONS = [
    '.jpg', '.JPG', '.jpeg', '.JPEG',
    '.png', '.PNG', '.ppm', '.PPM', '.bmp', '.BMP',
]

MAX_IMAGES = 2000
# IMAGE_SIZE = (512, 512)
IMAGE_SIZE = (256, 256)
# IMAGE_SIZE = (128, 128)
# IMAGE_SIZE = (64, 64)

def is_image_file(filename):
    return any(filename.endswith(extension) for extension in IMG_EXTENSIONS)


def make_dataset(dir):
    images = []
    assert os.path.isdir(dir), '%s is not a valid directory' % dir

    count = 0
    for root, _, fnames in sorted(os.walk(dir)):
        for fname in fnames:
            if is_image_file(fname):
                path = os.path.join(root, fname)
                images.append(path)
                count += 1
                if count > MAX_IMAGES:
                    break
    return images

parser = argparse.ArgumentParser('create numpy data from image folders')
parser.add_argument('--root', help='data directory', type=str, default='./receipts')
args = parser.parse_args()

root = args.root

for subset in ['val', 'train']:
    print("Loading images for", subset)
    # dir_A = os.path.join(root, '%sA' % subset)
    # dir_B = os.path.join(root, '%sB' % subset)
    dir_A = REAL_PATH
    dir_B = SYNTH_PATH
    A_paths = sorted(make_dataset(dir_A))
    B_paths = sorted(make_dataset(dir_B))
    mem_A_np = []
    mem_B_np = []

    # Convert to np array
    print("Converting A for ", subset)
    for i, A in enumerate(A_paths):
        mem_A_np.append(np.asarray(Image.open(A).convert('RGB').resize(IMAGE_SIZE, Image.BICUBIC)))
        if i % 100 == 0:
            print(i)

    print("Converting B for ", subset)
    # Convert to np array
    for i, B in enumerate(B_paths):
        mem_B_np.append(np.asarray(Image.open(B).convert('RGB').resize(IMAGE_SIZE, Image.BICUBIC)))
        if i % 100 == 0:
            print(i)

    full_A = np.stack(mem_A_np)
    full_B = np.stack(mem_B_np)

    A_size = len(mem_A_np)
    B_size = len(mem_B_np)
    print("%sA size=%d" % (subset, A_size))
    print("%sB size=%d" % (subset, B_size))
    # np.save(os.path.join(root, "%sA" % subset), full_A)
    # np.save(os.path.join(root, "%sB" % subset), full_B)
    np.save(os.path.join(root, "{}A_{}".format(subset, IMAGE_SIZE[0])), full_A)
    np.save(os.path.join(root, "{}B_{}".format(subset, IMAGE_SIZE[0])), full_B)
