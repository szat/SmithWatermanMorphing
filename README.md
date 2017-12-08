# SmithWatermanMorphing
A morphing algorithm for contours (sequence of 2D points) based the the SmithWaterman algorithm. Loosely based on Jiang's, Bunke's, Abegglen's and Kandel's "Curve Morphing by Weighted Mean of Strings".

## Getting Started

This little project morphs 2D contours or curves into another target contour or curve. The inspiration was the paper "Curve Morphing by Weighted Mean of Strings", but the resulting implemented method ended up quite different. The method works best when both shapes are somewhat similar. Moreover, the curves have to be sampled on average at constant distance. 

### Prerequisites

For this to run you need Matlab installed, along these toolboxes:
	-image_toolbox
	-statistics_toolbox

## Author

Adrian Szatmari 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Warm thanks to X. Jiang, H. Bunke, K. Abegglen, and A. Kandel for their excellent paper. 
