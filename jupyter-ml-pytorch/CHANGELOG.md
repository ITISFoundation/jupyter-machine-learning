# Changelog

## [2.0.2] - 2022-07-25
- Bumping up cuda from `11.0` to `11.2`

## [2.0.1] - 2022-05-08
- shell and kernel now use the same python interpreter
- fixes issue crashing when trusting notebooks
- fixes issue crashing when copying README.ipynb

## [2.0.0] - 2022-05-23
### Changed
- service is now ran via `dynamic-sidecar`
- upgraded `PyTorch` to version `1.11.0`
- upgraded `python` to `3.9.12`

## [1.0.6] - 2021-06-22
### Changed
- updates simcore service library to reduce cpu usage when extracting archives
## [1.0.5] - 2021-06-03
### Changed
 - move from VRAM to AIRAM

## [1.0.4] - 2021-03-22
### Fixed
- fixed requirements
## [1.0.3] - 2021-03-22
### Changed
- updated simcore-sdk to 0.3.2

## [1.0.2] - 2020-03-09
### Fixed
- fixed versioning config
- state_puller no longer causes out of memory errors causing the entire app to crash
- state puller will no longer allow the notebook to boot upon error when recovering the status
### Changed
- upgraded simcore-sdk and dependencies

### Added
- this changelog

