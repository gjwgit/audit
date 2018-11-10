# Install and configure Ubuntu system dependencies for the pre-built model.
#
# We choose to install user local packages using install-packages()
# rather than OS supplied packages to minimise the need for sys admin
# access from within mlhub. R itself is often operating system
# installed though not necessarily.

# Use atril to display PDF files. to avoid broken evince on Azure DSVM.

cat("Install system dependencies if needed...\n atril\n\n")
system("sudo apt-get install -y atril", ignore.stderr=TRUE, ignore.stdout=TRUE)

# Identify the required R packages for this model.

packages <- c("rpart", "magrittr", "rpart.plot", "RColorBrewer")

# Determine which packages need to be installed.

install  <- packages[!(packages %in% installed.packages()[,"Package"])]

# Report on what is already installed.

already <- setdiff(packages, install)
if (length(already))
{
    cat("The following required R packages are already installed:\n",
        paste(already, collapse=" "))
}

# Install into the package local R library.

lib <- file.path("./R")

# Ensure the library exists.

dir.create(lib, showWarnings=FALSE, recursive=TRUE)

# Install any packages into the local R library.

if (length(install))
{
  cat(sprintf("Installing '%s' into '%s'...", paste(install, collapse="', '"), lib))
  install.packages(install, lib=lib)
}
cat("\n")

# Additional specific packages, often as an interim measure.

if (FALSE)
{
  cat("We also need to install these specific package versions...\n")

  pkgs <- c("https://cran.r-project.org/src/contrib/Archive/rpart.plot/rpart.plot_3.0.4.tar.gz")
  for (pkg in pkgs)
  {
    cat("", basename(pkg), "\n")
    install.packages(pkg, repos=NULL, lib=lib)
  }
}
