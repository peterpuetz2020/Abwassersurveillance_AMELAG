# read in data for single treatment plants
plot_data <- read_tsv(here(read_data_here, "amelag_einzelstandorte.tsv")) %>%
  filter(!is.na(viruslast)) %>%
  # create week variable
  mutate(woche = as.Date(cut(datum, "week"))) %>%
  group_by(typ, woche) %>%
  # count number of observations and share of observations
  # below limit of quantification per virus and week
  count(unter_bg) %>%
  mutate(proportion = n / sum(n)) %>%
  mutate(unter_bg = factor((unter_bg == "ja") * 1, levels = c("1", "0"))) %>%
  ungroup() %>%
  # take only most recent year
  group_by(typ) %>%
  filter(woche >= max(woche) - 365) %>%
  ungroup()

# loop through virus types and make plots for each of them
for (vir in unique(plot_data$typ)) {
  # use self-defined functions to generate plots
  loq_plot(plot_data = plot_data, virus = vir)
}
