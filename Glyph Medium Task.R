
# Load required packages
library(cubble)  # For glyph plotting
library(ggplot2)  # For plotting
library(sf)  # For spatial data handling

# Define custom geometric function for glyph triangles
geom_glyph_triangle <- function(mapping = NULL, data = NULL, stat = "identity",
                                position = "identity", ..., x_major = NULL,
                                y_major = NULL, x_minor = NULL, y_minor = NULL,
                                polar = FALSE, width = ggplot2::rel(2.1),
                                height = ggplot2::rel(2.1), show.legend = NA,
                                inherit.aes = TRUE) {
    ggplot2::layer(data = data,
                   mapping = mapping,
                   stat = stat,
                   geom = GeomGlyphTriangle,
                   position = position,
                   show.legend = show.legend,
                   inherit.aes = inherit.aes,
                   params = list(
                     polar = polar,
                     width = width,
                     height = height,
                     ...
                   )
    )
}

# Define the custom geometric object for glyph triangles
GeomGlyphTriangle <- ggplot2::ggproto("GeomGlyphTriangle", ggplot2::Geom,
    # Function to setup data for plotting
    setup_data = function(data, params) {
        data <- cubble:::glyph_data_setup(data, params)
        calc_ref_triangle(data, params)
    },
    # Function to draw panel
    draw_panel = function(data, panel_params, coord, ...) {
        ggplot2:::GeomPolygon$draw_panel(data, panel_params, coord, ...)
    },
    required_aes = c("x_major", "y_major", "x_minor", "y_minor"),
    default_aes = ggplot2:::GeomPolygon$default_aes,
    extra_params = c("height", "width", "polar", "na.rm")
)

# Function to calculate triangle vertices
calc_ref_triangle <- function(data, params){
    if (any(data$polar)) {
        # Three points for a triangle
        theta <- seq(0, 2 * pi, length.out = 3)  
        ref_triangle <- data |>  
            dplyr::mutate(group = .data$group,
                          x1 = .data$x_major,
                          y1 = .data$y_major,
                          x2 = .data$x_major + .data$width / 4 * cos(theta),
                          y2 = .data$y_major + .data$height / 4 * sin(theta),
                          x3 = .data$x_major + .data$width / 4 * cos(2 * pi / 3 + theta),
                          y3 = .data$y_major + .data$height / 4 * sin(2 * pi / 3 + theta)
            )
    } else {
        ref_triangle <- data |> 
            dplyr::mutate(x1 = .data$x_major,
                          y1 = .data$y_major + .data$height / 2,
                          x2 = .data$x_major - .data$width / 2,
                          x3 = .data$x_major + .data$width / 2,
                          y2 = .data$y_major - .data$height / 2,
                          y3 = .data$y_major - .data$height / 2)
    }

    data.frame(x = c(ref_triangle$x1, ref_triangle$x2, ref_triangle$x3),
               y = c(ref_triangle$y1, ref_triangle$y2, ref_triangle$y3),
               PANEL = data$PANEL[1],
               group = data$group,
               polar = data$polar[1],
               width = data$width[1],
               height = data$height[1])
}

# Load required packages
library(dplyr)
# Set seed for reproducibility
set.seed(12345)
# Sample 80 rows from climate_aus dataset
(tmax <- climate_aus |>
    rowwise() |>
    filter(nrow(ts) == 366) |>
    slice_sample(n = 80))

# Reshape tmax data
(tmax <- tmax |>
  face_temporal() |>
  group_by(month = tsibble::yearmonth(date)) |>
  summarise(tmax = mean(tmax, na.rm = TRUE)))

# Unfold the data for longitude and latitude
(tmax <- tmax |> unfold(long, lat))

# Plotting
tmax |>
  ggplot(aes(x_major = long, y_major = lat,
             x_minor = month, y_minor = tmax)) +
  geom_sf(data = ozmaps::abs_ste,
          fill = "grey95", color = "white",
          inherit.aes = FALSE) +
  geom_glyph_triangle(width = 1.5, height = 2) +
  coord_sf() +
  labs(x = "Longitude", y = "Latitude") +
  theme_void() +
  theme(legend.position = "bottom")
