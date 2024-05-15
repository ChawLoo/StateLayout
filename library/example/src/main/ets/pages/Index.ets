import { router, SelectTitleBar } from '@kit.ArkUI';
import StateLayout from 'StateLayout/src/main/ets/components/StateLayout';
import StateController from 'StateLayout/src/main/ets/components/StateController';

@Entry
@Component
struct Index {
  controller: StateController = new StateController()
  @State message: string = 'Hello World';
  singleEmpty: boolean = false

  aboutToAppear(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    const timerId = setInterval(() => {
      this.controller.content()
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
              this.controller.loading()
              break
            case 1:
              this.controller.empty({
                emptyStr: !this.singleEmpty ? '我是单次显示修改后的空白缺省文案' : '',
                emptyIcon: $r('app.media.state_empty')
              })
              this.singleEmpty = true
              break
            case 2:
              this.controller.error({ retryStr: '给我重试' })
              break
            case 3:
              this.controller.networkError()
              break
            case 4:
              this.controller.content()
              break
          }
        },
        hidesBackButton: false
      })
      StateLayout({
        controller: this.controller,
        retry: () => {
          this.loading()
        },
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