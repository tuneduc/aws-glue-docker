A Dockerfile to run AWS Glue Python scripts locally.


Currently only Glue 1.0 is supported.

# How to use

This Dockerfile was created with the intention of being a base image to your actual project.

All you need to do is begin your Dockerfile with

```
from dockertuneduc/aws-glue:latest
```

And your image will have the correct Python version, Glue libs already installed, and awsglue module on your PYTHONPATH.

There's no need to use AWS's wrapper scripts (`gluepyspark`, `gluesparksubmit` and `gluepytest`). Running plain old `pyspark` and `spark-submit` should work normally.


As of right now we are not versioning the images.

## Contributing

Feel free to open issues with problems or suggestions, but please open an issue before submitting PRs.
