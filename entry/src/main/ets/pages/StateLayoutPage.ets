import { StateEnum, StateLayout } from '@chawloo/state-layout';

@Entry
@ComponentV2
struct StateLayoutPage {
  @Local message: string = 'Hello World';
  @Local state: StateEnum = StateEnum.EMPTY //很神奇，本地默认的值居然比不过全局默认状态

  @Builder
  contentBuilder() {
    Text(this.message)
      .fontSize(30)
  }

  onDidBuild(): void {
    setTimeout(() => {
      this.state = StateEnum.ERROR
    }, 1000)
  }

  build() {
    Column() {
      Row() {
        StateLayout({
          state: this.state,
          contentBuilder: () => {
            this.contentBuilder()
          }
        })
      }
      .layoutWeight(1)

      Button('改变状态')
        .onClick(() => {
          this.state = StateEnum.LOADING
          setTimeout(() => {
            this.state = StateEnum.CONTENT
          }, 2000)
        })
    }
    .height('100%')
    .width('100%')
  }
}