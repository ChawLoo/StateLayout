import { StateEnum } from 'StateLayout/src/main/ets/components/StateEnum';
import { router, SelectTitleBar } from '@kit.ArkUI';
import StateConfig from 'StateLayout/src/main/ets/components/StateConfig';
import StateLayoutComponent from 'StateLayout/src/main/ets/components/StateLayoutComponent';
import StateEventDispatcher from 'StateLayout/StateLayout';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  @State config: StateConfig = new StateConfig()
  @State state: StateEnum = StateEnum.LOADING
  stateEvent = new StateEventDispatcher()

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    const timerId = setInterval(() => {
      this.state = StateEnum.CONTENT
      clearInterval(timerId)
    }, 2000)
  }

  build() {
    Column() {
      SelectTitleBar({
        options: [
          { value: '加载中' },
          { value: '空白页' },
          { value: '错误页' },
          { value: '没有网络' },
          { value: '加载成功' },
        ],
        selected: 0,
        onSelected: (index) => {
          switch (index) {
            case 0:
              this.state = StateEnum.LOADING
              break
            case 1:
              this.config.emptyStr = '不一样的空白页文案' //修改后当前页面就一直是这个，除非再次修改
              this.config.emptyIcon = $r('app.media.state_empty') //修改后当前页面就一直是这个，除非再次修改
              this.stateEvent.empty()
              break
            case 2:
              this.config.retryStr = '给我重试' //修改后当前页面就一直是这个，除非再次修改
              this.stateEvent.error()
              break
            case 3:
              this.stateEvent.networkError()
              break
            case 4:
              this.stateEvent.content()
              break
          }
        },
        hidesBackButton: false
      })
      StateLayoutComponent({
        state: this.state,
        stateConfig: this.config,
        retry: () => {

        },
        eventID: this.stateEvent.eventID
      }) {
        Text(`加载成功后的内容:::${this.message}`)
          .fontSize(30)
          .fontColor(Color.Black)
          .onClick(() => {
            router.pushUrl({
              url: "pages/StateLayoutPage"
            })
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}