import slider, strformat, midio_ui

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
        max = 10.0, 
        defaultValue = 6.5, 
        onValueChanged = printValue
      )

when defined(js):
  import midio_ui_canvas
  startApp(
    render,
    "rootCanvas",
    "nativeContainer"
  )
when defined(c):
  import midio_ui_cairo
  startApp(render)
