import cryptoFramework from '@ohos.security.cryptoFramework';
import { StateEnum } from './StateEnum';
import emitter from '@ohos.events.emitter';

export default class StateEventDispatcher {
  eventID: number = 0

  constructor() {
    const now = Date.now()
    this.eventID = this.uint8ArrayToNumber(cryptoFramework.createRandom().generateRandomSync(6).data) + now
  }

  /**
   * 字节流转成可理解的字符串
   * @param uint8Array
   * @returns
   */
  private uint8ArrayToNumber(uint8Array: Uint8Array): number {
    return uint8Array.reduce((acc, val) => acc * 256 + val, 0)
  }

  loading() {
    emitter.emit({
      eventId: this.eventID, priority: emitter.EventPriority.IMMEDIATE
    },
      {
        data: {
          'state': StateEnum.LOADING
        }
      }
    );
  }

  empty() {
    emitter.emit({
      eventId: this.eventID, priority: emitter.EventPriority.IMMEDIATE
    },
      {
        data: {
          'state': StateEnum.EMPTY
        }
      }
    );
  }

  error() {
    emitter.emit({
      eventId: this.eventID, priority: emitter.EventPriority.IMMEDIATE
    },
      {
        data: {
          'state': StateEnum.ERROR
        }
      }
    );
  }

  content() {
    emitter.emit({
      eventId: this.eventID, priority: emitter.EventPriority.IMMEDIATE
    },
      {
        data: {
          'state': StateEnum.CONTENT
        }
      }
    );
  }

  networkError() {
    emitter.emit({
      eventId: this.eventID, priority: emitter.EventPriority.IMMEDIATE
    },
      {
        data: {
          'state': StateEnum.NETWORK_ERROR
        }
      }
    );
  }
}

