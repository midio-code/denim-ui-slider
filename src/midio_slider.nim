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

  let thumbPos = behaviorSubject(sliderMaxPos * defaultValue)
  let val = thumbPos.map(
    proc(pos: float): float =
      pos / sliderMaxPos
  )

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
          let newXPos = min(max(0.0, thumbPos.value + delta.x), sliderMaxPos)
          thumbPos.next(newXPos)
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
