# Glyph-Maps-Solutions
##Easy: Download the cubble package and run the glyph map examples (?geom_glyph)

Solution: First I installed the latest released version of cubble from CRAN with:
          ```R install.packages("cubble")```
          Example:
          ```R 
          library(cubble)
          library(ggplot2)
            # basic glyph map with reference line and box---------------
           p <- ggplot(data = GGally::nasa,
           aes(x_major = long, x_minor = day,
           y_major = lat, y_minor = surftemp)) +
           geom_glyph_box() +
           geom_glyph_line() +
           geom_glyph() +
           theme_bw()
           print_p(p)
           ```

##Medium: Read the Geoms section in the ggplot2 package reference and other geoms available in the ggplot2 extensions. Create a example that is applicable to be used as a glyph on a map.

Solution:
  
          
