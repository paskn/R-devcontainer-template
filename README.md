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

The template should also work with VS Code without DevPod, but I did
not test it. It works in GitHub Codespaces.

# Checklists

## Before building the workspace
1. Look at `./.devcontainer/devcontainer.json`:

    - Do you need to change R version?
    - Do you need `renv` to install packages listed in the template `renv.lock`?
    - Do you want to keep the template `postCreateCommand`?
    - If you want to use [Quarto](https://quarto.org/), you need to
      add it as a [feature](https://github.com/rocker-org/devcontainer-features/tree/main/src/quarto-cli).

2. Did you configure your (remote) provider or you want to run it locally? If remote:
    - Check the type of machine DevPod will request. Is it cheap/good? 
    - Is the timeout setting set properly?
    
## During the session
- Install packages with `renv::install()`.
- Periodically run `renv::status()` and `renv::snapshot()`.

# Remote computing with DevPod

To offload computing a pipeline to a remote machine with DevPod:

1. With DevPod, spawn a new workspace with your provider. Make sure to
   turn-off inactivity timeout in provider settings.
2. Use `nohup` to run the pipeline:

```sh
nohup R -e "targets::tar_make()" &
```

Now, `nohup` will log the pipeline into nohup.out file. You can track
how it updates with `tail -f nohup.out`.

`jobs` will print out the status of your pipeline. Now you can
logout/exit. `scp` can transfer files between remote and local
machines. 

Note: With DevPod you cannot change timeout for an already spawned
workspace (valid for version 0.5.18 on Aug 9 2024). DevPod will not
consider a running `nohup` command as an activity and will shutdown
your workspace after you logout.

# Resources

- [The {targets} R package user manual](https://books.ropensci.org/targets/). Sections 13 and 14
  about performance and distributed computing. 
- [Set up GitHub Actions to run a targets pipeline](https://docs.ropensci.org/targets/reference/tar_github_actions.html)
- [rocker-org/devcontainer-features/](https://github.com/rocker-org/devcontainer-features/tree/main/src/quarto-cli). README and NOTES files in `src` are especially useful.
