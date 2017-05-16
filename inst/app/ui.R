
## ui for data menu in radiant
do.call(navbarPage,
  c("radiant.dose",
    getOption("radiant.nav_ui"),
    getOption("Edit.nav_ui"),
    getOption("radiant.shared_ui"),
    help_menu("help_dose_ui"))
)

