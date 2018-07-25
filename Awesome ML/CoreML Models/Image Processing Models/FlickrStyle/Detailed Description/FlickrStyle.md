# Authors and Contributors

Sergey Karayev, Matthew Trentacoste, Helen Han, Aseem Agarwala,  Trevor Darrell, Aaron Hertzmann, Holger Winnemoeller, University of California, Berkeley, Adobe.

# Abstract

The style of an image plays a significant role in how it is viewed, but style has received little attention in computer vision research. We describe an approach to predicting style of images, and perform a thorough evaluation of different image features for these tasks. We find that features learned in a multi-layer network generally perform best – even when trained with object class (not style) labels. Our large-scale learning methods results in the best published performance on an existing dataset of aesthetic ratings and photographic style annotations. We present two novel datasets: 80K Flickr photographs annotated with 20 curated style labels, and 85K paintings annotated with 25 style/genre labels. Our approach shows excellent classification performance on both datasets. We use the learned classifiers to extend traditional tag-based image search to consider stylistic constraints, and demonstrate cross-dataset understanding of style.

## Input

A colour (227x227) image.

## Output

The most likely style of image, for the given input.

## License

Public Domain.
