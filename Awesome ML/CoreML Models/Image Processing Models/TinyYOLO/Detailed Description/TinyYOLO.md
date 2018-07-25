# Authors and Contributors

The Tiny YOLO network from the paper "YOLO9000: Better, Faster, Stronger" (2016), arXiv:1612.08242. Original paper: Joseph Redmon, Ali Farhadi.

# Functionality

YOLO actually looks at the image just once (hence its name: You Only Look Once) but in a clever way. YOLO divides up the image into a grid of 13 by 13 cells. Each of these cells is responsible for predicting 5 bounding boxes. A bounding box describes the rectangle that encloses an object. YOLO also outputs a confidence score that tells us how certain it is that the predicted bounding box actually encloses some object. This score doesn’t say anything about what kind of object is in the box, just if the shape of the box is any good. For each bounding box, the cell also predicts a class. This works just like a classifier: it gives a probability distribution over all the possible classes. The confidence score for the bounding box and the class prediction are combined into one final score that tells us the probability that this bounding box contains a specific type of object.

## Input

A colour (416x416) image.

## Output

The 13x13 grid with the bounding box data.

## License

Public Domain.
