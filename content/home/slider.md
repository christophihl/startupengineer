+++
# Slider widget.
widget = "slider"  # See https://sourcethemes.com/academic/docs/page-builder/
headless = true  # This file represents a page section.
active = true  # Activate this widget? true/false
weight = 10  # Order that this section will appear.

# Slide interval.
# Use `false` to disable animation or enter a time in ms, e.g. `5000` (5s).
interval = 5000

# Slide height (optional).
# E.g. `500px` for 500 pixels or `calc(100vh - 70px)` for full screen.
height = ""

# Slides.
# Duplicate an `[[item]]` block to add more slides.
[[item]]
  title = "Team"
  content = "<p>&nbsp;</p>"
  # content = "Smart. Dedicated. Supportive."
  align = "left"  # Choose `center`, `left`, or `right`.

  # Overlay a color or image (optional).
  #   Deactivate an option by commenting out the line, prefixing it with `#`.
  # overlay_color = "#666"  # An HTML color value.
  overlay_img = "team.jpg"  # Image path relative to your `static/img/` folder.
  overlay_filter = 0.1  # Darken the image. Value in range 0-1.
  overlay_caption = "&copy; [Anne Gärtner](https://www.gaertner-photo.de)"

  # Call to action button (optional).
  #   Activate the button by specifying a URL and button label below.
  #   Deactivate by commenting out parameters, prefixing lines with `#`.
  cta_label = "Meet our team."
  cta_url = "/team/"
  cta_icon_pack = "fas"
  cta_icon = "users"

[[item]]
  title = "Research"
  content = "<p>&nbsp;</p>"
  # content = "Relevant. Evidence-based. Data-driven."
  align = "left"

  # overlay_color = "#555"  # An HTML color value.
  overlay_img = "research.jpg"  # Image path relative to your `static/img/` folder.
  overlay_filter = 0.1  # Darken the image. Value in range 0-1.
  overlay_caption = "&copy; [Anne Gärtner](https://www.gaertner-photo.de)"

  cta_label = "Explore our research."
  cta_url = "/research/"
  cta_icon_pack = "fas"
  cta_icon = "search"

[[item]]
  title = "Teaching"
  content = "<p>&nbsp;</p>"
  # content = "Challenging. Team-oriented. Project-based."
  align = "left"

  # overlay_color = "#333"  # An HTML color value.
  overlay_img = "teaching.jpg"  # Image path relative to your `static/img/` folder.
  overlay_filter = 0.1  # Darken the image. Value in range 0-1.
  overlay_caption = "&copy; [Anne Gärtner](https://www.gaertner-photo.de)"

  cta_label = "Choose our courses."
  cta_url = "/teaching/"
  cta_icon_pack = "fas"
  cta_icon = "graduation-cap"

[[item]]
  title = "Transfer"
  content = "<p>&nbsp;</p>"
  # content = "Inspiring. Customized. Solution-oriented."
  align = "left"

  # overlay_color = "#333"  # An HTML color value.
  overlay_img = "practice.jpg"  # Image path relative to your `static/img/` folder.
  overlay_filter = 0.1 # Darken the image. Value in range 0-1.
  overlay_caption = "&copy; [Anne Gärtner](https://www.gaertner-photo.de)"

  cta_label = "Let's work together."
  cta_url = "/practice/"
  cta_icon_pack = "fas"
  cta_icon = "cogs"


+++
