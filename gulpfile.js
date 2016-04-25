var gulp = require('gulp');
var ts = require('gulp-typescript');
var webpack = require('gulp-webpack');
var rename = require("gulp-rename");

gulp.task('typescript', function() {
  // if(process.env.RAILS_ENV === 'production') tasks.push('rev');
  return gulp.src('./gulp/assets/typescripts/*.ts')
  .pipe(ts({
    noImplicitAny: true
  }))
  .pipe(gulp.dest('./gulp/assets/javascripts'));
});

gulp.task('webpack', ['typescript'], function() {
  return gulp.src('./gulp/assets/javascripts/*.js')
    .pipe(webpack())
    .pipe(rename('final.js'))
    .pipe(gulp.dest('./public/assets/javascripts'));
});
