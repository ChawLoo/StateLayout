import { StateController, StateEnum, StateLayout } from '@chawloo/state-layout';

@Entry
@ComponentV2
struct StateLayoutPage {
  @Local message: string = 'Hello World';
  @Local controller: StateController = new StateController()

  @Builder
  contentBuilder() {
    Text(this.message)
      .fontSize(30)
      .textAlign(TextAlign.Center)
      .width('100%')
  }

  onDidBuild(): void {
    setTimeout(() => {
      this.controller.state = StateEnum.CONTENT
    }, 1000)
  }

  build() {
    Column() {
      Row() {
        StateLayout({
          controller: this.controller,
          contentBuilder: () => {
            this.contentBuilder()
          }
        })
      }
      .layoutWeight(1)

      Button('改变状态')
        .onClick(() => {
          this.controller.state = StateEnum.LOADING
          setTimeout(() => {
            this.controller.state = StateEnum.CONTENT
          }, 2000)
        })
    }
    .height('100%')
    .width('100%')
  }
}