# compe-nvim

notmuch address completion source for [nvim-compe](https://github.com/hrsh7th/nvim-compe).

## Usage

For `packer`:

```lua

use {
    'faximilie/compe-notmuch',
    requires = 'hrsh7th/nvim-compe',
    after = 'nvim-compe',
    config = [[require('compe-notmuch').setup()]],
}

require('compe').setup({
    source = {
        vCard = true,
        -- probably some other sources as well
    }
})
```

## Credits

Heavily modified from [completion-vcard](https://github.com/cbarrete/completion-vcard)
