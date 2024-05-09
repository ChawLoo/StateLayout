import StateConfig from './StateConfig'
import { StateEnum } from './StateEnum'
import emitter from '@ohos.events.emitter'

@Builder
function NothingBuilder() {
}

@Component
export default struct StateLayoutComponent {
  @Link state: StateEnum
  @Link stateConfig: StateConfig
  @BuilderParam public contentBuilder: () => void = NothingBuilder
  eventID?: number
  retry: () => void = () => {
  }

  aboutToAppear(): void {
    // 监听指定ID为1的事件
    emitter.on({ eventId: this.eventID ?? -1 }, (event) => {
      // 如果事件携带数据，则调用子组件方法处理数据
      if (event.data && event.data.state) {
        if (this.state == event.data.state) {
          return
        }
        console.log(`收到状态更新：${event.data.state}`)
        this.state = event.data.state
      }
    });
  }

  build() {
    Column() {
      if (this.state == StateEnum.LOADING) {
        this.DefaultLoadingBuilder()
      } else if (this.state == StateEnum.EMPTY) {
        this.DefaultEmptyBuilder()
      } else if (this.state == StateEnum.ERROR) {
        this.DefaultErrorBuilder()
      } else if (this.state == StateEnum.NETWORK_ERROR) {
        this.DefaultNetworkErrorBuilder()
      } else {
        this.contentBuilder()
      }
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Center)
    .layoutWeight(1)
  }

  @Builder
  DefaultLoadingBuilder() {
    LoadingProgress()
      .color(this.stateConfig.progressColor)
      .size({ width: 64 })
    Text(this.stateConfig.loadingStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultEmptyBuilder() {
    Image(this.stateConfig.emptyIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.stateConfig.emptyStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultErrorBuilder() {
    Image(this.stateConfig.errorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.stateConfig.errorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.stateConfig.retryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        if (this.state == StateEnum.ERROR) {
          this.state = StateEnum.LOADING
        }
        this.retry()
      })
  }

  @Builder
  DefaultNetworkErrorBuilder() {
    Image(this.stateConfig.networkErrorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.stateConfig.networkErrorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.stateConfig.retryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        this.retry()
      })
  }
}