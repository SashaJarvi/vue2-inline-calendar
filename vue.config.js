const { defineConfig } = require("@vue/cli-service");

module.exports = defineConfig({
  publicPath: process.env.NODE_ENV === "production" ? "/vue2-inline-calendar/" : "/",
  transpileDependencies: true,
  css: {
    extract: false,
  },
});
