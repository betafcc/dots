export type Message = {
  role: string
  content: string
}

export type CreateCompletion = (messages: Array<Message>) => Promise<string>

export class Agent {
  static create(
    createCompletion: CreateCompletion,
    messages: Array<Message> = [],
  ) {
    return new Agent(createCompletion, messages)
  }

  static createAzure(messages: Array<Message> = [], temperature = 0.1) {
    return new Agent(
      messages =>
        fetch(Deno.env.get('AZURE_HOST')!, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'api-key': Deno.env.get('AZURE_KEY')!,
          },
          redirect: 'follow',
          body: JSON.stringify({
            temperature,
            messages,
          }),
        })
          .then(r => r.json())
          .then(r => r.choices[0].message.content),
      messages,
    )
  }

  constructor(
    readonly createCompletion: CreateCompletion,
    readonly messages: Array<Message>,
  ) {}

  add(role: string, content: string) {
    return new Agent(
      this.createCompletion,
      this.messages.concat([{ role, content }]),
    )
  }

  user(content: string) {
    return this.add('user', content)
  }

  system(content: string) {
    return this.add('system', content)
  }

  assistant(content: string) {
    return this.add('assistant', content)
  }

  last() {
    return this.messages.at(-1)?.content
  }

  complete() {
    return this.createCompletion(this.messages).then(content =>
      this.add('assistant', content),
    )
  }
}
