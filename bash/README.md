### Notes to self

from this awesome [stack overflow answer](https://stackoverflow.com/questions/9953005/should-the-bashrc-in-the-home-directory-load-automatically/9954208#9954208)

```
                     +-----------------+   +------FIRST-------+   +-----------------+
                     |                 |   | ~/.bash_profile  |   |                 |
login shell -------->|  /etc/profile   |-->| ~/.bash_login ------>|  ~/.bashrc      |
                     |                 |   | ~/.profile       |   |                 |
                     +-----------------+   +------------------+   +-----------------+
                     +-----------------+   +-----------------+
                     |                 |   |                 |
interactive shell -->|  ~/.bashrc -------->| /etc/bashrc     |
                     |                 |   |                 |
                     +-----------------+   +-----------------+
                     +-----------------+
                     |                 |
logout shell ------->|  ~/.bash_logout |
                     |                 |
                     +-----------------+
```

**Note**

1. `[]-->[]` means `source by workflow` (Automatically).
- `[--->[]` means `source by convention` （Manually. If not, nothing happen.）.
- `FIRST` means `find the first available, ignore rest`
