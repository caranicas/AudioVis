var gulp = require('gulp')
var coffee  = require('gulp-coffee')

gulp.task('coffeecheck', function() {
  gulp.src('app/scripts/site/form/*.coffee')
    .pipe(coffee({bare:true}))
    .pipe(gulp.dest('coffeetest'));
});
