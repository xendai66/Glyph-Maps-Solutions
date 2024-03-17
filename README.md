# Glyph-Maps-Solutions
## Easy: Download the cubble package and run the glyph map examples (?geom_glyph) 

**Solution**:  First I installed the latest released version of cubble from CRAN with:
          ```install.packages("cubble")
          ```
         
          library(cubble)
          library(ggplot2)
          
          #basic glyph map with reference line and box---------------
          
          print_p <- GGally::print_if_interactive
          p <- ggplot(data = GGally::nasa,
          aes(x_major = long, x_minor = day,
          y_major = lat, y_minor = surftemp)) +
          geom_glyph_box() +
          geom_glyph_line() +
          geom_glyph() +
          theme_bw()
          print_p(p)
          


           
        

         

           
![gsoc easy plot](https://github.com/xendai66/Glyph-Maps-Solutions/assets/114280549/bd0e3a13-eb28-4a4c-b556-7ef19b7b6ac8)

## Medium: Read the Geoms section in the ggplot2 package reference and other geoms available in the ggplot2 extensions. Create a example that is applicable to be used as a glyph on a map.


  **Solution**: Github Link
  
          
