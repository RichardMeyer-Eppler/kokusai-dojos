library(rnaturalearth)
library(ragg)
library(ggplot2)
library(ggrepel)
library(tibble)
library(here)

# Constants -----------------------------------------------------------------------------------

yellow <- "#fcd500"
date <- Sys.Date()

path_image <- here::here(
  "images",
  paste0(
    date,
    "_kokusai_dojos.png"
  )
)

caption <- paste0(
  "This version: ",
  date,
  "\nSource: https://github.com/RichardMeyer-Eppler/kokusai-dojos"
)

# Data sources --------------------------------------------------------------------------------

df_dojos <- 
  tibble::tribble(
    ~row_number,                   ~Dojo,        ~lon,        ~lat,
    1L,            "Muso-juku Asahikawa", 142.3649743,   43.770625,
    2L,             "Gensei-kan Sapporo", 141.3542924,   43.061936,
    3L,           "Genshin-kan Kisarazu", 139.9247334,  35.3810808,
    4L,  "Esaka Dojo Kurashukan Matsudo",  139.903177,  35.7879371,
    5L,             "Esaka Dojo Shibuya", 139.6987107,  35.6645956,
    6L,            "Shoken-kai Fujisawa",  139.465077,   35.364842,
    7L,             "Genshin-kan Taipei", 121.5636796,  25.0375198,
    8L,           "Genshin-kan Taichung", 120.6478282,   24.163162,
    9L,          "Genshin-kan Kaohsiung", 120.3120375,  22.6203348,
    10L,            "Genyo-kan Singapore", 103.8519072,   1.2899175,
    11L, "Nihon Budo-kai Nizhny Novgorod", 43.91950225,  56.2950165,
    12L,       "Katsujinken-kai Pretoria",  28.1879101, -25.7459277,
    13L,              "Esaka Dojo Berlin",  13.3888599,  52.5170365,
    14L,             "Esaka Dojo Potsdam",  13.0591397,  52.4009309,
    15L,              "Esaka Dojo Laufen", 12.90745005,  47.9283096,
    16L,           "Esaka Dojo Stuttgart",   9.1800132,  48.7784485,
    17L,           "Esaka Dojo Bielefeld",    8.531007,  52.0191005,
    18L,             "Esaka Dojo Münster",   7.6251879,  51.9625101,
    19L,                  "Dojo Dortmund",  7.46391855, 51.51331715,
    20L,          "Kendo Verein Kevelaer",  6.26750675,  51.5900281,
    21L,              "Makoto Dojo Paris",   2.3483915,  48.8534951,
    22L,                   "Boston Iaido",  -71.060511,  42.3554334,
    23L,               "Genwakan Alamada", -122.241635,  37.7652076,
    24L,            "Genwakan Emeryville", -122.272863,  37.8708393,
    25L,           "Esaka Dojo Vancouver", -123.159479,  49.3311208,
    26L,        "Ken Shin Dojo Vancouver", -123.159479,  49.3311208,
    27L,          "Todo Kai Dojo Nanaimo", -123.938122,   49.163877
  )


mapWorld <- rnaturalearth::ne_countries(
  type = "countries",
  continent = c(
    "Europe",
    "Africa",
    "Asia",
    "North America",
    "South America"
  ),
  scale = "small",
  returnclass = "sf"
)

# Create image of Kokusai dojos ---------------------------------------------------------------

ragg::agg_png(
  path_image, 
  width = 2500,
  height = 1498, 
  res = 72,
  scaling = 4
)

ggplot2::ggplot(
  df_dojos,
  mapping = ggplot2::aes(
    x = lon,
    y = lat,
    color = Dojo
  )
) +
  ggplot2::geom_sf(
    data = mapWorld,
    color = "black",
    inherit.aes = FALSE
  ) +
  ggrepel::geom_label_repel(
    fill = "black",
    label.size = 0.2,
    segment.linetype = "solid",	
    segment.color = "#8E4A49",  # is the line segment color
    segment.size = 0.7,    # is the line segment thickness
    segment.alpha = 1,    # is the line segment transparency
    label.padding = 0.1,
    alpha = 0.8,
    ggplot2::aes(
      label = row_number
    ),
    min.segment.length = 0,
    max.overlaps = 50
  ) +
  ggplot2::scale_color_manual(
    name = NULL,
    values = rep(yellow, nrow(df_dojos)),
    labels = rev(df_dojos$Dojo)
  ) +
  ggplot2::guides(
    color = ggplot2::guide_legend(
      override.aes = list(
        label = rev(df_dojos$row_number),
        size = ggplot2::rel(
          2.8
        )
      )
    )
  ) +
  ggplot2::labs(
    title = "一般社団法人 正統正流無雙直傳英信流居合道国際連盟",
    subtitle = "World MJER Iaido Federation – Seito Seiryu Muso Jikiden Eishin Ryu Iaido Kokusai Renmei",
    caption = caption
  ) +
  ggplot2::theme_void() +
  ggplot2::theme(
    text = ggplot2::element_text(
      color = yellow
    ),
    panel.background = ggplot2::element_rect(
      fill = "black"
    ),
    plot.background = ggplot2::element_rect(
      fill = "black"
    ),
    legend.position = "bottom",
    legend.text = ggplot2::element_text(
      size = ggplot2::rel(
        0.6
      )
    ),
    legend.key.size = ggplot2::unit(
      0.4,
      "cm"
    )
    ,legend.spacing.x = ggplot2::unit(
      0.2,
      "lines"
    ),
    plot.caption = ggplot2::element_text(
      size = ggplot2::rel(
        0.6
      ),
      face = "italic"
    )
  )

dev.off()