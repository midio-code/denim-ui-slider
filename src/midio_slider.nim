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

component Slider(
  min: float,
  max: float, 
  defaultValue: float, 
  onValueChanged: (float) -> void
):
  let hoveringThumb = behaviorSubject(false)
  let circleRadius = 8.0
  let sliderWidth = 200.0

  let sliderMaxPos = (sliderWidth - circleRadius * 2.0)
  
  proc valToPos(val: float): float =
    lerp(min, max, val) * sliderMaxPos

  proc posToVal(pos: float): float =
    pos / sliderMaxPos
  
  let val = behaviorSubject(defaultValue)
  let thumbPos = val.map(valToPos)

  discard val.subscribe(
    onValueChanged
  )

  panel(width = sliderWidth):
    rectangle(color = "teal")
    rectangle(color = "yellow", height = 4.0, margin = thickness(circleRadius), verticalAlignment = VerticalAlignment.Center)
    circle(
      x <- thumbPos,
      radius = circleRadius,
      color <- hoveringThumb.choose("orange", "red"), 
      verticalAlignment = VerticalAlignment.Center
    ):
      hoveringThumb.onHover()
      onDrag(
        proc(delta: Vec2[float]): void =
          val.next(clamp(val.value + posToVal(delta.x), min, max))
      )


proc render(): Element = 
  let val = behaviorSubject(0.5)
  proc printValue(x: float): void =
    val.next(x)
  panel:
    rectangle(color = "blue")
    stack(horizontalAlignment = HorizontalAlignment.Center):
      text(text <- val.map(
        proc(x: float): string =
          &"val: {x}"
      ))
      Slider(
        min = 0.0, 
        max = 1.0, 
        defaultValue = 0.5, 
        onValueChanged = printValue
      )

startApp(
  render,
  "rootCanvas",
  "nativeContainer"
)
