function(kalibr_python_setup)
  cmake_parse_arguments(PARSE_ARGV 0 KPY
    ""
    "PACKAGE_DIR"
    "PACKAGES"
  )

  set(PACKAGE_DIR ${KPY_PACKAGE_DIR})
  if(NOT PACKAGE_DIR)
    set(PACKAGE_DIR "python")
  endif()

  # 为每个Python包创建__init__.py
  foreach(pkg ${KPY_PACKAGES})
    set(pkg_dir ${CMAKE_CURRENT_SOURCE_DIR}/${PACKAGE_DIR}/${pkg})
    if(EXISTS ${pkg_dir})
      set(init_file ${pkg_dir}/__init__.py)
      if(NOT EXISTS ${init_file})
        file(WRITE ${init_file} "")
      endif()
    endif()
  endforeach()

  # 使用distutils安装Python模块
  set(SETUP_PY_CONTENT "
from setuptools import setup, find_packages
import os
import sys

def main():
    setup(
        name='${PROJECT_NAME}',
        version='0.0.1',
        packages=${KPY_PACKAGES},
        package_dir={'': '${PACKAGE_DIR}'},
        install_requires=[
            'numpy',
            'scipy',
            'matplotlib'
        ],
        author='ETH Zurich',
        description='Kalibr Calibration Toolbox',
        license='New BSD',
        classifiers=[
            'Programming Language :: Python :: 3',
            'License :: OSI Approved :: BSD License',
            'Operating System :: POSIX :: Linux',
        ],
    )

if __name__ == '__main__':
    main()
")

  set(SETUP_PY_PATH ${CMAKE_CURRENT_BINARY_DIR}/setup.py)
  file(WRITE ${SETUP_PY_PATH} "${SETUP_PY_CONTENT}")

  # 添加安装目标
  install(CODE "
execute_process(
    COMMAND ${Python3_EXECUTABLE} ${SETUP_PY_PATH} install --prefix=${CMAKE_INSTALL_PREFIX}
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    RESULT_VARIABLE setup_result
    OUTPUT_VARIABLE setup_output
    ERROR_VARIABLE setup_error
)

if(setup_result)
    message(FATAL_ERROR \"Python setup failed: ${setup_error}\")
else()
    message(STATUS \"Python setup succeeded: ${setup_output}\")
endif()
")
endfunction()
