import StateConfig, { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig'
import { StateEnum } from './StateEnum'
import { StateController } from './StateController'
import { isNotBlank } from './Util'
import GlobalStateConfig from '../../../../Index'

@Builder
function NothingBuilder() {
}

@ComponentV2
export struct StateLayout {
  @Local showLoadingWhenRetry: boolean = StateConfig.globalStateConfig.showLoadingWhenRetry
  @Local localState: StateEnum = StateConfig.globalStateConfig.defaultState
  @Param state: StateEnum = StateConfig.globalStateConfig.defaultState
  @Local localLoadingStr: string = StateConfig.globalStateConfig.loadingStr
  @Local localProgressColor: ResourceColor = StateConfig.globalStateConfig.progressColor
  @Local localEmptyStr: string = StateConfig.globalStateConfig.emptyStr
  @Local localEmptyIcon: Resource = StateConfig.globalStateConfig.emptyIcon
  @Local localErrorStr: string = StateConfig.globalStateConfig.errorStr
  @Local localErrorIcon: Resource = StateConfig.globalStateConfig.errorIcon
  @Local localRetryStr: string = StateConfig.globalStateConfig.retryStr
  @Local localNetworkErrorStr: string = StateConfig.globalStateConfig.networkErrorStr
  @Local localNetworkErrorIcon: Resource = StateConfig.globalStateConfig.networkErrorIcon
  @Event priorityRetry?: () => void // 优先加载，用于单次传入的retry
  @Event retry: () => void
  @Param controller: StateController = new StateController();
  @BuilderParam public contentBuilder: () => void = NothingBuilder

  @Monitor('state')
  onStateChange() {
    this.localState = this.state
  }

  onDidBuild(): void {
    if (this.controller) {
      this.controller.loadingEvent = this.loading
      this.controller.emptyEvent = this.empty
      this.controller.errorEvent = this.error
      this.controller.networkErrorEvent = this.networkError
      this.controller.contentEvent = this.content
    }
  }

  private loading = (config?: LoadingConfig) => {
    if (config?.loadingStr) {
      this.localLoadingStr = isNotBlank(config.loadingStr) ? config.loadingStr : StateConfig.globalStateConfig.loadingStr
    }
    this.localState = StateEnum.LOADING
  }
  private empty = (config?: EmptyConfig) => {
    if (config?.emptyStr) {
      this.localEmptyStr = isNotBlank(config?.emptyStr) ? config?.emptyStr : StateConfig.globalStateConfig.emptyStr
    } else {
      this.localEmptyStr = StateConfig.globalStateConfig.emptyStr
    }
    if (config?.emptyIcon) {
      this.localEmptyIcon = config?.emptyIcon ?? StateConfig.globalStateConfig.emptyIcon
    } else {
      this.localEmptyIcon = StateConfig.globalStateConfig.emptyIcon
    }
    this.localState = StateEnum.EMPTY
  }
  private error = (config?: ErrorConfig) => {
    if (config?.errorStr) {
      this.localErrorStr = isNotBlank(config?.errorStr) ? config?.errorStr : StateConfig.globalStateConfig.errorStr
    } else {
      this.localErrorStr = StateConfig.globalStateConfig.errorStr
    }
    if (config?.errorIcon) {
      this.localErrorIcon = config?.errorIcon ?? StateConfig.globalStateConfig.errorIcon
    } else {
      this.localErrorIcon = StateConfig.globalStateConfig.errorIcon
    }
    if (config?.retryStr) {
      this.localRetryStr = isNotBlank(config?.retryStr) ? config?.retryStr : StateConfig.globalStateConfig.retryStr
    } else {
      this.localRetryStr = StateConfig.globalStateConfig.retryStr
    }
    this.priorityRetry = config?.retry
    if (config?.retry) {
      if (config?.isCoverRetry !== undefined && config.isCoverRetry) {
        this.retry = config.retry
      }
    }
    if (config?.showLoadingWhenRetry !== undefined) {
      this.showLoadingWhenRetry = config.showLoadingWhenRetry
    } else {
      this.showLoadingWhenRetry = StateConfig.globalStateConfig.showLoadingWhenRetry
    }
    this.localState = StateEnum.ERROR
  }
  private networkError = (config?: NetworkErrorConfig) => {
    if (config?.networkErrorStr) {
      this.localNetworkErrorStr = isNotBlank(config?.networkErrorStr) ? config?.networkErrorStr : StateConfig.globalStateConfig.networkErrorStr
    } else {
      this.localNetworkErrorStr = StateConfig.globalStateConfig.networkErrorStr
    }
    if (config?.networkErrorIcon) {
      this.localNetworkErrorIcon = config?.networkErrorIcon ?? StateConfig.globalStateConfig.networkErrorIcon
    } else {
      this.localNetworkErrorIcon = StateConfig.globalStateConfig.networkErrorIcon
    }
    if (config?.retryStr) {
      this.localRetryStr = isNotBlank(config?.retryStr) ? config?.retryStr : StateConfig.globalStateConfig.retryStr
    } else {
      this.localRetryStr = StateConfig.globalStateConfig.retryStr
    }
    this.priorityRetry = config?.retry
    if (config?.retry) {
      if (config?.isCoverRetry !== undefined && config.isCoverRetry) {
        this.retry = config.retry
      }
    }
    if (config?.showLoadingWhenRetry !== undefined) {
      this.showLoadingWhenRetry = config.showLoadingWhenRetry
    } else {
      this.showLoadingWhenRetry = StateConfig.globalStateConfig.showLoadingWhenRetry
    }
    this.localState = StateEnum.NETWORK_ERROR
  }
  private content = () => {
    this.localState = StateEnum.CONTENT
  }

  build() {
    Column() {
      if (this.localState == StateEnum.LOADING) {
        if (GlobalStateConfig.globalLoadingBuilder) {
          GlobalStateConfig.globalLoadingBuilder.builder({
            loadingStr: this.localLoadingStr,
            progressColor: this.localProgressColor
          })
        } else {
          this.DefaultLoadingBuilder()
        }
      } else if (this.localState == StateEnum.EMPTY) {
        if (GlobalStateConfig.globalEmptyBuilder) {
          GlobalStateConfig.globalEmptyBuilder.builder({
            emptyStr: this.localEmptyStr,
            emptyIcon: this.localEmptyIcon
          })
        } else {
          this.DefaultEmptyBuilder()
        }
      } else if (this.localState == StateEnum.ERROR) {
        if (GlobalStateConfig.globalErrorBuilder) {
          GlobalStateConfig.globalErrorBuilder.builder({
            errorStr: this.localErrorStr,
            errorIcon: this.localErrorIcon,
            retryStr: this.localRetryStr,
            retry: this.priorityRetry ?? this.retry,
            showLoadingWhenRetry: this.showLoadingWhenRetry
          })
        } else {
          this.DefaultErrorBuilder()
        }
      } else if (this.localState == StateEnum.NETWORK_ERROR) {
        if (GlobalStateConfig.globalNetworkBuilder) {
          GlobalStateConfig.globalNetworkBuilder.builder({
            networkErrorStr: this.localNetworkErrorStr,
            networkErrorIcon: this.localNetworkErrorIcon,
            retryStr: this.localRetryStr,
            retry: this.priorityRetry ?? this.retry,
            showLoadingWhenRetry: this.showLoadingWhenRetry
          })
        } else {
          this.DefaultNetworkErrorBuilder()
        }
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
      .color(this.localProgressColor)
      .size({ width: 64 })
    Text(this.localLoadingStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultEmptyBuilder() {
    Image(this.localEmptyIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.localEmptyStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
  }

  @Builder
  DefaultErrorBuilder() {
    Image(this.localErrorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.localErrorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.localRetryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        if (this.showLoadingWhenRetry && this.localState != StateEnum.LOADING) {
          this.localState = StateEnum.LOADING
        }
        if (this.priorityRetry) {
          this.priorityRetry()
        } else {
          if (this.retry) {
            this.retry()
          }
        }
      })
  }

  @Builder
  DefaultNetworkErrorBuilder() {
    Image(this.localNetworkErrorIcon)
      .fitOriginalSize(true)
      .width('70%')
    Text(this.localNetworkErrorStr)
      .fontSize(16)
      .fontColor(0xFFA9B7B7)
      .margin(8)
    Text(this.localRetryStr)
      .fontSize(16)
      .fontColor(0xFF3369E7)
      .margin({ top: 10 })
      .onClick(() => {
        if (this.showLoadingWhenRetry && this.localState != StateEnum.LOADING) {
          this.localState = StateEnum.LOADING
        }
        if (this.priorityRetry) {
          this.priorityRetry()
        } else {
          if (this.retry) {
            this.retry()
          }
        }
      })
  }
}