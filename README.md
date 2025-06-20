# High Scripts Facade

A simple and lightweight facade for High-Scripts resources exports, designed to make integration with the [High Phone](https://high-scripts.com/) and other High-Scripts resources easier and safer.
This project provides a unified interface to interact with High-Scripts exports, handling resource state checks and error handling for you.

## Features

- **Unified API:** Access High-Scripts exports from a single, consistent interface.
- **Resource State Safety:** Automatically checks if a resource is started before calling its exports.
- **Error Handling:** Catches and logs errors from export calls, preventing script crashes.
- **Extensible:** Easily add support for more High-Scripts resources.

## Usage

1. **Add the facade to your cfg file:**
    ```cfg
    ensure high-scripts-facade
    ```

2. **Add the facade lua file to your fxmanifest**
    ```lua
    ---  eg. resources/myAwesomeScript/fxmanifest.lua at the top of the file
    shared_script '@high-scripts-facade/facade.lua';
    ```

3. **Use the facade in your scripts:**
    ```lua
    -- Example: Calling a shared phone export
    local phone <const> = HighScripts.Shared.Phone;
    phone.addApplication('myapp', { /* app config */ }, { /* locales */ });
    ```

4. **Resource Safety:**
    - The facade ensures the target resource (e.g., `high-phone`) is started before calling its exports.
    - Errors are logged to the console for easier debugging.

## Contributing

Contributions are welcome! If you have ideas, improvements, or want to add support for more High-Scripts resources:

- Fork the repository
- Create a new branch for your feature or fix (feat/my-feature-name)
- Submit a pull request with a clear description

Feel free to open issues for bugs, suggestions, or questions.

## License

[MIT License](./LICENSE)

---

Made with ❤️ for the FiveM community.
