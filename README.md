# dtv-ppa(-test)

```bash
curl -s --compressed "https://kounoike.github.io/dtv-ppa-test/main/KEY.gpg" | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/dtv_ppa.gpg >/dev/null && \
 echo "deb [signed-by=/etc/apt/trusted.gpg.d/dtv_ppa.gpg] https://kounoike.github.io/dtv-ppa-test/main ./" | sudo tee /etc/apt/sources.list.d/dtv_ppa.list >/dev/null
```
