# install.packages("tidyverse")
# install.packages("ggplot2")
library(tidyverse)
library(ggplot2)

setwd("G:/My Drive/Universidad/2025-1/Haciendo-Econom-a")
#How to-Hacer la tabla
df <- tribble(
  ~Munic_Dept, ~usaInternet1, ~usaInternet2, ~usaInternet3, ~usaInternet4, ~usaInternet5, ~usaInternet6, ~usaInternet7, ~usaInternet8, ~usaInternet9, ~usaInternet10, ~usaInternet11,
  "BEL",     35.29,         70,     84.21,    71.43,    80,    75,     0,    45.45, 62.5,  75,   100,
  "BAQ",     57.89,         55,     88.24,    25,       50,    80,   100,    68.42, 72.73, 63.16, 81.82,
  "BTA",    70.59,       73.91,    50,       57.14,  76.92,  84.62, 100,    80,    66.67, 43.75, 62.5,
  "GIR",    28.85,       63.33,    77.78,    0,       0,     91.67, 63.64,  0,     71.43, 75,    50,
  "SOA",    25,          54.17,    83.33,    87.5,    75,    68.75, 100,    86.67, 66.67, 81.82, 50,
  "ZIP",    85.71,       76.92,    75,       66.67,  70,    100,   100,    73.33, 100,   90,    0,
  "NVA",    22.22,       36.36,    100,      100,     93.75, 100,   100,    94.12, 100,   64.52, 62.5,
  "PEI",    48,          63.16,    66.67,    66.67,   60,    66.67, 66.67,  100,   100,   57.14, 0,
  "BGA",    28.57,       60,       90,       95.24,   80,    87.5,  57.14,  75,    100,   84.62, 100,
  "IBE",    30.77,       50,       80,       11.11,   50,    44.44, 80,     33.33, 85.71, 66.67, 66.67
)



df_long <- df %>%
  pivot_longer(
    cols = starts_with("usaInternet"),
    names_to = "Actividad", 
    values_to = "Porcentaje"
  ) %>%
  mutate(
    Actividad = factor(
      Actividad,
      levels = c(
        "usaInternet1","usaInternet2","usaInternet3","usaInternet4","usaInternet5",
        "usaInternet6","usaInternet7","usaInternet8","usaInternet9","usaInternet10",
        "usaInternet11"
      )
    )
  )


etiquetas_acts <- c(
  usaInternet1  = "Tienda (1)",
  usaInternet2  = "Comida prep. (2)",
  usaInternet3  = "Peluquería (3)",
  usaInternet4  = "Ropa (4)",
  usaInternet5  = "Otras var. (5)",
  usaInternet6  = "Papelería (6)",
  usaInternet7  = "Vida noct. (7)",
  usaInternet8  = "Prod. invent. (8)",
  usaInternet9  = "Salud (9)",
  usaInternet10 = "Servicios (10)",
  usaInternet11 = "Ferretería (11)"
)



p <- ggplot(df_long, aes(x = Actividad, y = Munic_Dept, fill = Porcentaje)) +
  geom_tile(color = "white") +
  scale_fill_gradientn(
    colours = c("#2166ac", "#67a9cf", "#d1e5f0", "#fddbc7", "#ef8a62", "#b2182b"),
    limits = c(0,100),
    name = "Uso de \nInternet (%)"
  ) +
  scale_x_discrete(labels = etiquetas_acts) +
  labs(
    title = "Proporción de Negocios con Internet por Municipio y Actividad",
    x = "Actividad Económica",
    y = "Municipio"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1), 
    panel.grid = element_blank()
  )

print(p)

ggsave("Output/heatmap_munic_actividad.png", plot = p, width = 10, height = 5)
