import { Controller, Get } from '@nestjs/common';

@Controller()
export class AppController {
  @Get()
  getHome(): { 
    message: string 
  } {
    return {
      message: 'Welcome to YiPetHome!',
    };
  }
}
