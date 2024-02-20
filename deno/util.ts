
export const post = (url: string, data: any, headers?: any) =>
  fetch(url, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      ...headers,
    },
    redirect: 'follow',
    body: JSON.stringify(data),
  })
