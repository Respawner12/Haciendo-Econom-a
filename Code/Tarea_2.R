library(haven)
library(dplyr)
library(tidyr)
library(stringr)
library(readxl)
library(haven)
library(dplyr)
library(tidyr)
library(stringr)
library(readxl)

setwd("G:/My Drive/Universidad/2025-1/Haciendo-Econom-a")

df <- read_dta("RAW/TenderosFU03_Publica.dta")
actividad_cols <- c("Munic_Dept", paste0("actG", 1:11))
df[actividad_cols] <- lapply(df[actividad_cols], as.numeric)

df_tenderos <- df %>%
  group_by(Munic_Dept) %>%
  summarise(
    n_tiendas_totales = n(),
    across(starts_with("actG"), sum, na.rm = TRUE)
  )

df_internet <- df %>%
  filter(uso_internet == 1) %>%
  group_by(Munic_Dept) %>%
  summarise(
    n_tiendas_internet = n(),
    across(starts_with("actG"), sum, na.rm = TRUE)
  )

df_merged <- inner_join(df_tenderos, df_internet, by = "Munic_Dept", suffix = c(".total", ".internet")) %>%
  mutate(proporcion_internet = (n_tiendas_internet / n_tiendas_totales) * 100)

df_poblacion <- read_excel("RAW/TerriData_Dim2_Sub3.xlsx")
df_poblacion <- df_poblacion[-1, ]
df_poblacion <- df_poblacion %>%
  rename(Munic_Dept = "Código Entidad") %>%
  mutate(Munic_Dept = as.numeric(str_remove(Munic_Dept, "^0+")))

df_merged <- df_merged %>% left_join(df_poblacion, by = "Munic_Dept")

df_long <- df_merged %>%
  select(Munic_Dept, starts_with("actG")) %>%
  pivot_longer(
    cols = -Munic_Dept,
    names_to = c("Actividad", ".value"),
    names_pattern = "(actG\\d+)\\.(total|internet)"
  ) %>%
  group_by(Munic_Dept, Actividad) %>%
  summarise(
    total = sum(total, na.rm = TRUE),
    internet = sum(internet, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(prop_internet = if_else(total == 0, 0, round((internet / total) * 100, 2)))

df_wide <- df_long %>%
  select(Munic_Dept, Actividad, prop_internet) %>%
  pivot_wider(
    names_from = Actividad,
    values_from = prop_internet,
    names_prefix = "usaInternet"
  )

names(df_wide) <- str_replace(names(df_wide), "usaInternetactG", "usaInternet")
head(df_wide)

write.csv(df_wide, "Output/df_wide_resultado.csv", row.names = FALSE)

