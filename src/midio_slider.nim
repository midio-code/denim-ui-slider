import sugar
import strformat
import midio_ui
import midio_ui_canvas

proc onHover(self: Subject[bool]): Behavior =
  onHover(
    proc(e: Element): void = 
      self.next(true),
    proc(e: Element): void =
      self.next(false)
  )

proc render(): Element = 
  let hoveringThumb = behaviorSubject(false)
  let circleRadius = 8.0
  let thumbPos = behaviorSubject(vec2(0.0))
  let sliderWidth = 200.0

  let thumbXPos = thumbPos.extract(x).map(
    proc(val: float): float =
      min(max(0.0, val), sliderWidth - circleRadius * 2.0)
  )

  let val = thumbXPos.map(
    proc(p: float): float =
      p / (sliderWidth - circleRadius * 2.0)
  )
  panel:
    rectangle(color = "blue")
    stack(horizontalAlignment = HorizontalAlignment.Center):
      text(text <- val.map(
        proc(x: float): string =
          &"val: {x}"
      ))
      panel(width = sliderWidth):
        rectangle(color = "teal")
        rectangle(color = "yellow", height = 4.0, margin = thickness(circleRadius), verticalAlignment = VerticalAlignment.Center)
        circle(
          x <- thumbXPos,
          radius = circleRadius,
          color <- hoveringThumb.choose("orange", "red"), 
          verticalAlignment = VerticalAlignment.Center
        ):
          hoveringThumb.onHover()
          onDrag(
            proc(delta: Vec2[float]): void =
              thumbPos.next(thumbPos.value + delta)
          )

startApp(
  render,
  "rootCanvas",
  "nativeContainer"
)
