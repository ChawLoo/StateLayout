import StateConfig from 'StateLayout/src/main/ets/components/StateConfig';
import { StateEnum } from 'StateLayout/src/main/ets/components/StateEnum';
import StateLayoutComponent from 'StateLayout/src/main/ets/components/StateLayoutComponent';
import StateEventDispatcher from 'StateLayout/StateLayout';

@Entry
@Component
struct StateLayoutPage {
  @State message: string = 'Hello World';
  @State state: StateEnum = StateEnum.CONTENT
  @State config: StateConfig = new StateConfig()
  stateEvent: StateEventDispatcher = new StateEventDispatcher()

  build() {
    Column() {
      StateLayoutComponent({
        state: this.state,
        stateConfig: this.config,
        eventID: this.stateEvent.eventID
      }) {
        Text(this.message)
          .fontSize(30)
        Button('发送子组件消息')
          .onClick(() => {
            this.stateEvent.empty()
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}