export default class StateConfig {
  static globalStateConfig: StateConfig | undefined = undefined
  loadingStr: string = '加载中...'
  progressColor: ResourceColor = '#FF3369E7'
  emptyStr: string = '暂无数据'
  emptyIcon: Resource = $r('app.media.ic_state_empty')
  errorStr: string = '加载失败'
  errorIcon?: Resource = $r('app.media.ic_state_error')
  networkErrorStr: string = '网络不稳定，请重试'
  networkErrorIcon: Resource = $r('app.media.ic_state_network')
  retryStr: string = '重新加载'

  constructor() {
    if (StateConfig.globalStateConfig) {
      this.loadingStr = StateConfig.globalStateConfig.loadingStr
      this.progressColor = StateConfig.globalStateConfig.progressColor
      this.emptyStr = StateConfig.globalStateConfig.emptyStr
      this.emptyIcon = StateConfig.globalStateConfig.emptyIcon
      this.errorStr = StateConfig.globalStateConfig.errorStr
      this.errorIcon = StateConfig.globalStateConfig.errorIcon
      this.networkErrorStr = StateConfig.globalStateConfig.networkErrorStr
      this.networkErrorIcon = StateConfig.globalStateConfig.networkErrorIcon
      this.retryStr = StateConfig.globalStateConfig.retryStr
    }
  }

  loadingConfig(config: LoadingConfig): StateConfig {
    if (config.loadingStr) {
      this.loadingStr = config.loadingStr
    }
    if (config.progressColor) {
      this.progressColor = config.progressColor
    }
    return this
  }

  emptyConfig(config: EmptyConfig): StateConfig {
    if (config.emptyStr) {
      this.emptyStr = config.emptyStr
    }
    if (config.emptyIcon) {
      this.emptyIcon = config.emptyIcon
    }
    return this
  }

  errorConfig(config: ErrorConfig): StateConfig {
    if (config.errorStr) {
      this.errorStr = config.errorStr
    }
    if (config.errorIcon) {
      this.errorIcon = config.errorIcon
    }
    if (config.retryStr) {
      this.retryStr = config.retryStr
    }
    return this
  }

  networkErrConfig(config: NetworkErrorConfig): StateConfig {
    if (config.networkStr) {
      this.networkErrorStr = config.networkStr
    }
    if (config.networkIcon) {
      this.networkErrorIcon = config.networkIcon
    }
    if (config.retryStr) {
      this.retryStr = config.retryStr
    }
    return this
  }
}

interface LoadingConfig {
  loadingStr?: string
  progressColor?: ResourceColor
}

interface EmptyConfig {
  emptyStr?: string
  emptyIcon?: Resource
}

interface ErrorConfig {
  errorStr?: string
  errorIcon?: Resource
  retryStr?: string
}

interface NetworkErrorConfig {
  networkStr?: string
  networkIcon?: Resource
  retryStr?: string
}