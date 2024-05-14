import StateController from 'StateLayout/src/main/ets/components/StateController';
import StateLayout from 'StateLayout/src/main/ets/components/StateLayout';

@Entry
@Component
struct StateLayoutPage {
  @State message: string = 'Hello World';
  stateController = new StateController()

  build() {
    Column() {
      StateLayout({
        controller: this.stateController
      }) {
        Text(this.message)
          .fontSize(30)
        Button('发送子组件消息')
          .onClick(() => {
            this.stateController.empty()
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}