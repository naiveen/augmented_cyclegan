# Augmeted Cyclegan

Pytorch source code for https://arxiv.org/abs/1802.10151 originally written by the authors and forked from https://github.com/aalmah/augmented_cyclegan. 

The code is originally based on https://github.com/junyanz/pytorch-CycleGAN-and-pix2pix, and written in Python 2 and requires Pytorch 0.3.

We have made some minimal adjustments to the code so that it runs in Python 3.6 using Pytorch 0.4. 
Other changes include catching or preventing runtime errors for situations such as: pairing samples randomly from each dataset even when they do not have the same length, catching errors when the batch size does not evenly divide the total number of items, adjusted the networks to work with images of larger size, ...etc.

## Useful links

[GAN Presentation](https://docs.google.com/presentation/d/1hYFCrmelyfuUnlwXw1JfPCOzx-2gb1-4EBuOSfWkCsE/edit?usp=sharing)

[Experiment Blog](https://elementai.atlassian.net/wiki/x/toB2Hg)


## Cloning

```sh
git clone git@github.com:ElementAI/augmented_cyclegan.git
cd augmented_cyclegan
```

## Execution

A `Dockerfile` is provided to setup the environment. In addition, a `Makefile`
allows easy building and running.

The default `Makefile` target is `usage`, and gives basic information on how to
use it:

```sh
make usage
# or simply:
make
```

To run a basic Docker container:
```sh
make runi
```

To make changes to what volumes to mount, edit the `VOLUMES_TO_MOUNT` variable in `Makefile.cfg`.


## Creating the datasets

The model runs by first loading the datasets from a `npy` file format. 
Therefore, the first step is to convert your dataset of images into a numpy array format.

### Receipts: real vs synthetic

Assuming that each of the receipts datasets is in `/mnt/projects/ripples/data/real_receipts` and `/mnt/projects/whiskey_bear/data/generated/generated_100k_2018may11"`:

```sh
make runi
python datasets/create_receipts_np.py --imgSize 128 --maxImages 2000
```

This will generate `.npy` files inside `datasets/receipts` directory, with each file name (`trainA`, `trainB`, `valA`, `valB`) suffixed by the image size, here `128` (assuming square images). The default image size is `64` and the maximum size of the datasets is `2000`. 


## Running the model

From within Docker:

```sh
CUDA_VISIBLE_DEVICES=0 python edges2shoes_exp/train.py --dataroot datasets/receipts/ --name augcgan_model --niter 2000 --checkpoints_dir './checkpoints/receipts_512' --imgSize 512 --batchSize 2 --display_freq 500 --save_epoch_freq 1 --continue_train 

```

This will run the model on images of size `512` and save the output in `checkpoints/receipts_512`. 
For more details about all the command-line options, see `edges2shoes_exp/options.py`
