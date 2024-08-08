# Project template

This is a template for an R-project with
[devcontainer](https://containers.dev/)-type of workflow. The stack
includes:

- [Docker](https://www.docker.com/) and [DevPod](https://devpod.sh/)
- [renv](https://rstudio.github.io/renv/) and
  [targets](https://docs.ropensci.org/targets/index.html)
- [R Markdown](https://rmarkdown.rstudio.com/) notebooks with
  [knitr](https://yihui.org/knitr/)

The repo contains sample code to run a pipeline computing achieved
power (effect size sensitivity) for a mixed-effect model. The pipeline
will fail as the repo does not include the data.

To build the image:

```bash
devpod up .
```

In Emacs, find-file in the container using
[docker.el](https://github.com/Silex/docker.el/) and TRAMP. Edit as
usual with [ESS](https://github.com/emacs-ess/ESS).

The template should also work with VS Code without DevPod, but I did not test it.
