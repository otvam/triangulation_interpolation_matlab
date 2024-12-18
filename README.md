# MATLAB Code for Interpolating Triangulated Data

![license - BSD](https://img.shields.io/badge/license-BSD-green)
![language - MATLAB](https://img.shields.io/badge/language-MATLAB-blue)
![category - science](https://img.shields.io/badge/category-science-lightgrey)
![status - unmaintained](https://img.shields.io/badge/status-unmaintained-red)

The **MATLAB code** offers several functions for creating **2D triangulations** and **interpolating** data:
* creating **triangulation** from **scattered data**, using **alpha shapes**
    * handle ill-conditioned triangles
    * handle multiple (disjoint) domains
    * handle holes in the domains
* removing **ill-conditioned triangles**
    * skinny triangles on the exterior boundary 
    * triangles specified with a list of indices
* computing the **area** and the **angle** of the triangles
* **linear interpolation** on a specified triangulation
* **plotting** triangulation geometry and data

## Examples

### Angles and Ill-conditioned Triangles

<p float="middle">
    <img src="readme_img/tri_angle.png" width="350">
    <img src="readme_img/tri_geom.png" width="350">
</p>

<p float="middle">
    <img src="readme_img/tri_number.png" width="350">
    <img src="readme_img/tri_output.png" width="350">
</p>

### Triangulated and Interpolated Data

<p float="middle">
    <img src="readme_img/tri_plot.png" width="350">
    <img src="readme_img/tri_interp.png" width="350">
</p>

## Compatibility

* Tested with MATLAB R2021a.
* No toolboxes are required.
* Compatibility with GNU Octave not tested but probably easy to achieve.

## Author

**Thomas Guillod** - [GitHub Profile](https://github.com/otvam)

## License

This project is licensed under the **BSD License**, see [LICENSE.md](LICENSE.md).
