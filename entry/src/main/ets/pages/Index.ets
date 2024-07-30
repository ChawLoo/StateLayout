import { promptAction, router, SelectTitleBar } from '@kit.ArkUI';
import StateLayout from 'StateLayout/src/main/ets/components/StateLayout';
import StateController from 'StateLayout/src/main/ets/components/StateController';

@Entry
@ComponentV2
struct Index {
  controller: StateController = new StateController()
  @Local message: string = 'Hello World';

  onDidBuild(): void {
    this.loading()
  }

  //模拟网络加载
  loading() {
    setTimeout(() => {
      this.controller.content()
    }, 2000)
  }

  build() {
    Column() {
      SelectTitleBar({
        options: [
          { value: '加载中' },
          { value: '空白页（全局文案和图标）' },
          { value: '空白页（单例文案和图标）' },
          { value: '错误页' },
          { value: '错误页（单例重试按钮和事件）' },
          { value: '错误页（单例重试事件并覆盖）' },
          { value: '没有网络' },
          { value: '没有网络（自动显示加载）' },
          { value: '没有网络（不自动显示加载）' },
          { value: '未登录' },
          { value: '加载成功' },
        ],
        onSelected: (index) => {
          switch (index) {
            case 0:
              this.controller.loading()
              break
            case 1:
              this.controller.empty()
              break
            case 2:
              this.controller.empty({
                emptyStr: '我是单例空白文案',
                emptyIcon: $r('app.media.state_empty')
              })
              break
            case 3:
              this.controller.error()
              break
            case 4:
              this.controller.error({
                retryStr: '我是单例错误按钮',
                errorStr: `我是单例错误文案`,
                isCoverRetry: false, //不会覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是单例重试事件' })
                }
              })
              break
            case 5:
              this.controller.error({
                retryStr: '给我重试',
                errorStr: '单例重试事件，后续点击重试，执行覆盖的重试',
                isCoverRetry: true, //覆盖原来的重试，普通的error和netError后，重试时间被覆盖
                retry: () => {
                  promptAction.showToast({ message: '我是覆盖的重试事件' })
                }
              })
              break
            case 6:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试根据全局配置是否自动加载中）',
              })
              break
            case 7:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试自动显示加载中）',
                showLoadingWhenRetry: true
              })
              break
            case 8:
              this.controller.networkError({
                networkErrorStr: '网络错误（点击重试不会自动显示加载中）',
                showLoadingWhenRetry: false
              })
              break
            case 9:
              this.controller.error({
                errorStr: '未登录状态提示，等同于Error',
                retryStr: '立即登录',
                showLoadingWhenRetry: false,
                retry: () => {
                  promptAction.showToast({
                    message: '跳转登录的点击事件'
                  })
                }
              })
              break
            case 10:
              this.controller.content()
              break
          }
        },
        hidesBackButton: true
      })
      StateLayout({
        controller: this.controller,
        retry: () => {
          promptAction.showToast({ message: '我是最初重试事件' })
          this.loading()
        },
      }) {
        Text(`加载成功后的内容:::${this.message}(点击文案跳转直接修改的方案)`)
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