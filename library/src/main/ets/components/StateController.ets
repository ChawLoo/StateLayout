import { EmptyConfig, ErrorConfig, LoadingConfig, NetworkErrorConfig } from './StateConfig';

export default class StateController {
  loadingEvent?: (config?: LoadingConfig) => void

  loading(config?: LoadingConfig) {
    if (this.loadingEvent) {
      this.loadingEvent(config)
    }
  }

  emptyEvent?: (config?: EmptyConfig) => void

  empty(config?: EmptyConfig) {
    if (this.emptyEvent) {
      this.emptyEvent(config)
    }
  }

  errorEvent?: (config?: ErrorConfig) => void

  error(config?: ErrorConfig) {
    if (this.errorEvent) {
      this.errorEvent(config)
    }
  }

  networkErrorEvent?: (config?: NetworkErrorConfig) => void

  networkError(config?: NetworkErrorConfig) {
    if (this.networkErrorEvent) {
      this.networkErrorEvent(config)
    }
  }

  contentEvent = () => {
  }

  content() {
    this.contentEvent()
  }
}