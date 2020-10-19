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

proc invLerp(a, b, t: float): float = 
  (t - a) / (b - a)

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
    invLerp(min, max, val) * sliderMaxPos

  proc posToVal(pos: float): float =
    (pos / sliderMaxPos) * (max - min)

  proc restrictVal(value: float): float =
    clamp(value, min, max)

  let val = behaviorSubject(restrictVal(defaultValue))
  let thumbPos = val.map(valToPos)

  proc setVal(value: float): void =
    val.next(restrictVal(value))
  
  discard val.subscribe(
    proc(newVal: float): void =
      onValueChanged(newVal)
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
          setVal(val.value + posToVal(delta.x))
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
        min = 5.0, 
        max = 10.0, 
        defaultValue = 6.5, 
        onValueChanged = printValue
      )

startApp(
  render,
  "rootCanvas",
  "nativeContainer"
)
